#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "httpx",
#     "rich",
#     "typer",
#     "platformdirs",
#     "ghapi",
# ]
# ///

"""Download binaries from GitHub releases."""

import os
import platform
import stat
import tarfile
import zipfile
import tempfile
from pathlib import Path
from typing import Any, Annotated

import httpx
import typer
from rich.console import Console
from rich.progress import Progress, SpinnerColumn, TextColumn, BarColumn, DownloadColumn
from rich.table import Table
from rich.prompt import Prompt, Confirm
from ghapi.all import GhApi
from ghapi.core import HTTP403ForbiddenError

console = Console()
app = typer.Typer(
    help="Download binaries from GitHub releases.",
    no_args_is_help=True,
    rich_markup_mode="rich",
)


class GitHubReleaseDownloader:
    """Handle downloading binaries from GitHub releases."""

    def __init__(self, owner: str, repo: str, token: str | None = None):
        self.owner = owner
        self.repo = repo
        # ghapi handles rate limiting automatically
        self.api = GhApi(owner=owner, repo=repo, token=token)
        self.client = httpx.Client(follow_redirects=True, timeout=30.0)

    def __enter__(self):
        return self

    def __exit__(self, *args):
        self.client.close()

    def get_platform_info(self) -> tuple[list[str], str]:
        """Detect the current platform."""
        system = platform.system().lower()
        machine = platform.machine().lower()

        # Normalize machine architecture
        arch_map = {
            "x86_64": "amd64",
            "amd64": "amd64",
            "aarch64": "arm64",
            "arm64": "arm64",
            "armv7l": "armv7",
            "i386": "386",
            "i686": "386",
        }
        arch = arch_map.get(machine, machine)

        # Normalize OS names
        os_map = {
            "darwin": ["darwin", "macos", "osx"],
            "linux": ["linux"],
            "windows": ["windows", "win"],
        }

        os_names = os_map.get(system, [system])

        return os_names, arch

    def get_release(self) -> dict[str, Any]:
        """Fetch release information from GitHub."""
        try:
            release = self.api.repos.get_latest_release()
            return release
        except HTTP403ForbiddenError as e:
            if "rate limit" in str(e).lower():
                console.print("[red]GitHub API rate limit exceeded.[/red]")
                console.print(
                    "[yellow]Consider setting GH_RELEASE_GITHUB_TOKEN environment variable or using --token flag.[/yellow]"
                )
                raise typer.Exit(1)
            raise

    def get_release_by_tag(self, tag: str) -> dict[str, Any]:
        """Get a specific release by tag."""
        try:
            return self.api.repos.get_release_by_tag(tag)
        except HTTP403ForbiddenError as e:
            if "rate limit" in str(e).lower():
                console.print("[red]GitHub API rate limit exceeded.[/red]")
                console.print(
                    "[yellow]Consider setting GH_RELEASE_GITHUB_TOKEN environment variable or using --token flag.[/yellow]"
                )
                raise typer.Exit(1)
            raise

    def find_matching_assets(
        self,
        assets: list[dict[str, Any]],
        os_names: list[str],
        arch: str,
        pattern: str | None = None,
    ) -> list[dict[str, Any]]:
        """Find assets matching the current platform."""
        matches = []

        for asset in assets:
            name = asset["name"].lower()

            # Check if custom pattern matches
            if pattern:
                if pattern.lower() in name:
                    matches.append(asset)
                continue

            # Check OS match
            os_match = any(os_name in name for os_name in os_names)
            if not os_match:
                continue

            # Check architecture match
            arch_patterns = {
                "amd64": ["amd64", "x86_64", "x64", "64bit"],
                "arm64": ["arm64", "aarch64"],
                "armv7": ["armv7", "arm32", "armhf"],
                "386": ["386", "i386", "x86", "32bit"],
            }

            arch_match = False
            if arch in arch_patterns:
                arch_match = any(p in name for p in arch_patterns[arch])
            else:
                arch_match = arch in name

            if os_match and arch_match:
                matches.append(asset)

        return matches

    def download_file(self, url: str, dest: Path) -> None:
        """Download a file with progress bar."""
        with self.client.stream("GET", url) as response:
            response.raise_for_status()
            total = int(response.headers.get("content-length", 0))

            with Progress(
                SpinnerColumn(),
                TextColumn("[progress.description]{task.description}"),
                BarColumn(),
                DownloadColumn(),
                console=console,
            ) as progress:
                task = progress.add_task(f"Downloading {dest.name}", total=total)

                with open(dest, "wb") as f:
                    for chunk in response.iter_bytes(chunk_size=8192):
                        f.write(chunk)
                        progress.update(task, advance=len(chunk))

    def extract_binary(
        self,
        archive_path: Path,
        extract_to: Path,
        binary_name: str | None = None,
    ) -> Path | None:
        """Extract binary from archive with user selection if multiple files."""
        extracted_files = []

        def _extract_tar(tar: tarfile.TarFile):
            tar.extractall(path=extract_to, filter="data")
            return [
                extract_to / member.name
                for member in tar.getmembers()
                if member.isfile()
            ]

        def _extract_zip(zip_ref: zipfile.ZipFile):
            zip_ref.extractall(extract_to)
            return [
                extract_to / name
                for name in zip_ref.namelist()
                if not name.endswith("/")
            ]

        if archive_path.suffix == ".gz" and archive_path.stem.endswith(".tar"):
            with tarfile.open(archive_path, "r:gz") as tar:
                extracted_files = _extract_tar(tar)
        elif archive_path.suffix == ".zip":
            with zipfile.ZipFile(archive_path, "r") as zip_ref:
                extracted_files = _extract_zip(zip_ref)
        elif archive_path.suffix in [".tar", ".tgz"]:
            mode = "r:gz" if archive_path.suffix == ".tgz" else "r"
            with tarfile.open(archive_path, mode) as tar:
                extracted_files = _extract_tar(tar)
        else:
            return archive_path  # Direct binary

        if not extracted_files:
            console.print("[red]No files found in archive[/red]")
            return None

        if binary_name:
            for file in extracted_files:
                if file.name == binary_name or file.name == f"{binary_name}.exe":
                    # Ensure it's an actual executable
                    if os.access(file, os.X_OK) or not file.suffix:
                        return file

        # Show files and prompt user to pick one
        table = Table(title="Archive Contents")
        table.add_column("Index", justify="right", style="cyan")
        table.add_column("File Name", style="green")
        table.add_column("Size", justify="right")

        for idx, file in enumerate(extracted_files):
            size_kb = file.stat().st_size / 1024
            table.add_row(str(idx + 1), file.name, f"{size_kb:.1f} KB")

        console.print(table)


@app.command()
def main(
    repository: Annotated[
        str, typer.Argument(help="GitHub repository in format owner/repo")
    ],
    tag: Annotated[
        str | None, typer.Option("--tag", "-t", help="Specific release tag to download")
    ] = None,
    pattern: Annotated[
        str | None,
        typer.Option("--pattern", "-p", help="Custom pattern to match asset names"),
    ] = None,
    binary: Annotated[
        str | None,
        typer.Option(
            "--binary", "-b", help="Name of the binary to extract from archive"
        ),
    ] = None,
    output: Annotated[
        Path | None, typer.Option("--output", "-o", help="Output path for the binary")
    ] = None,
    install_dir: Annotated[
        Path, typer.Option("--install-dir", "-d", help="Installation directory")
    ] = Path("~/local/gh-release/bin"),
    list_assets: Annotated[
        bool,
        typer.Option("--list", "-l", help="List available assets without downloading"),
    ] = False,
    token: Annotated[
        str | None,
        typer.Option(
            "--token",
            help="GitHub personal access token (or set GH_RELEASE_GITHUB_TOKEN env var)",
        ),
    ] = None,
):
    """Download binaries from GitHub releases.

    [bold]Examples:[/bold]

        [green]# Download mise[/green]
        gh-release jdx/mise

        [green]# Download specific version[/green]
        gh-release cli/cli --tag v2.40.0

        [green]# Download with custom pattern[/green]
        gh-release ethereum/go-ethereum --pattern linux-amd64

        [green]# List available assets[/green]
        gh-release rust-lang/rust --list

        [green]# Use with GitHub token to avoid rate limits[/green]
        export GH_RELEASE_GITHUB_TOKEN=ghp_xxxxx
        gh-release owner/repo
    """
    # Parse repository
    parts = repository.split("/")
    if len(parts) != 2:
        console.print("[red]Repository must be in format owner/repo[/red]")
        raise typer.Exit(1)

    owner, repo = parts

    # Get token from environment if not provided
    if not token:
        token = os.environ.get("GH_RELEASE_GITHUB_TOKEN")

    with GitHubReleaseDownloader(owner, repo, token) as downloader:
        # Get platform info
        os_names, arch = downloader.get_platform_info()
        console.print(f"Platform: {os_names[0]}-{arch}")

        # Try to determine binary name
        if not binary:
            binary = repo

        try:
            # Get releases
            if tag:
                release = downloader.get_release_by_tag(tag)
            else:
                release = downloader.get_release()

            if not release:
                console.print("[red]No releases found[/red]")
                raise typer.Exit(1)

            # List mode
            if list_assets:
                console.print(f"\n[bold]Release: {release['tag_name']}[/bold]")
                if release.get("name"):
                    console.print(f"Name: {release['name']}")

                table = Table(title="Assets")
                table.add_column("Name", style="cyan")
                table.add_column("Size", style="green")
                table.add_column("Downloads", style="yellow")

                for asset in release["assets"]:
                    size_mb = asset["size"] / 1024 / 1024
                    table.add_row(
                        asset["name"],
                        f"{size_mb:.1f} MB",
                        str(asset["download_count"]),
                    )

                console.print(table)
                return

            # Find matching assets for the latest/specified release
            version = release["tag_name"]
            console.print(f"Release: [green]{version}[/green]")

            # Find matching assets
            matches = downloader.find_matching_assets(
                release["assets"], os_names, arch, pattern
            )

            if not matches:
                console.print("[red]No matching assets found[/red]")
                console.print("\nAvailable assets:")
                for asset in release["assets"]:
                    console.print(f"  - {asset['name']}")
                raise typer.Exit(1)

            # Select asset
            if len(matches) == 1:
                asset = matches[0]
            else:
                console.print("\nMultiple matching assets found:")
                for i, match in enumerate(matches, 1):
                    size_mb = match["size"] / 1024 / 1024
                    console.print(f"{i}. {match['name']} ({size_mb:.1f} MB)")

                choice = Prompt.ask(
                    "Select asset",
                    choices=[str(i) for i in range(1, len(matches) + 1)],
                )
                asset = matches[int(choice) - 1]

            console.print(f"Selected: [cyan]{asset['name']}[/cyan]")

            # Determine installation path
            install_path = install_dir.expanduser()
            install_path.mkdir(parents=True, exist_ok=True)

            if output:
                final_path = output.expanduser()
            else:
                final_path = install_path / binary

            # Check if file exists
            if final_path.exists():
                if not Confirm.ask(f"{final_path} already exists. Overwrite?"):
                    console.print("[yellow]Aborted[/yellow]")
                    raise typer.Exit(0)

            # Download
            download_url = asset["browser_download_url"]

            with tempfile.TemporaryDirectory() as tmpdir:
                tmp_path = Path(tmpdir)
                download_path = tmp_path / asset["name"]

                console.print(f"Downloading from: {download_url}")
                downloader.download_file(download_url, download_path)

                # Extract binary if needed
                console.print("Processing download...")
                binary_path = downloader.extract_binary(download_path, tmp_path, binary)

                if not binary_path:
                    console.print("[red]Could not find binary in archive[/red]")
                    raise typer.Exit(1)

                # Move to final location
                if final_path.exists():
                    final_path.unlink()

                if binary_path != download_path:
                    binary_path.rename(final_path)
                else:
                    # Direct binary download
                    download_path.rename(final_path)

                # Make executable
                final_path.chmod(final_path.stat().st_mode | stat.S_IEXEC)

            console.print(f"[green]✓ Successfully installed to {final_path}[/green]")

            # Check PATH
            if str(install_path) not in os.environ.get("PATH", ""):
                console.print(
                    f"\n[yellow]Note: {install_path} is not in your PATH.[/yellow]"
                )
                console.print(f'Add to PATH with: export PATH="{install_path}:$PATH"')

        except Exception as e:
            if "404" in str(e):
                console.print(
                    f"[red]Repository or release not found: {owner}/{repo}[/red]"
                )
                if tag:
                    console.print(f"[red]Tag '{tag}' may not exist[/red]")
            else:
                console.print(f"[red]Error: {e}[/red]")
            raise typer.Exit(1)


if __name__ == "__main__":
    app()
