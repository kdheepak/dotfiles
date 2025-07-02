#!/usr/bin/env -S uv run
# -*- coding: utf-8 -*-
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "httpx",
#     "rich",
#     "typer",
# ]
# ///
"""
GitHub Desktop installer script that downloads and installs GitHub Desktop for Windows
"""

import os
import subprocess
from pathlib import Path
import tempfile
import json

import typer
import httpx
from rich.console import Console
from rich.progress import (
    Progress,
    SpinnerColumn,
    TextColumn,
    BarColumn,
    DownloadColumn,
    TransferSpeedColumn,
)
from rich.prompt import Confirm
from rich.panel import Panel

# Configure console
console = Console()

app = typer.Typer(
    name=__name__, no_args_is_help=True, help=__doc__, add_completion=False
)

SCRIPT_NAME = f"./{Path(__file__).name}"


def check_github_desktop_installed() -> bool:
    """Check if GitHub Desktop is already installed"""
    try:
        # Check for GitHub Desktop in common installation paths
        username = os.environ.get("USERNAME", os.environ.get("USER", "User"))
        common_paths = [
            Path(
                f"C:\\Users\\{username}\\AppData\\Local\\GitHubDesktop\\GitHubDesktop.exe"
            ),
            Path("C:\\Program Files\\GitHub Desktop\\GitHubDesktop.exe"),
            Path("C:\\Program Files (x86)\\GitHub Desktop\\GitHubDesktop.exe"),
        ]

        for path in common_paths:
            if path.exists():
                return True

        # Try to run GitHub Desktop to check if it's in PATH
        result = subprocess.run(
            ["github-desktop", "--version"],
            capture_output=True,
            text=True,
            check=False,
            timeout=5,
        )
        return result.returncode == 0
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False


def get_github_desktop_location() -> Path | None:
    """Get the GitHub Desktop installation directory"""
    username = os.environ.get("USERNAME", os.environ.get("USER", "User"))
    common_paths = [
        Path(f"C:\\Users\\{username}\\AppData\\Local\\GitHubDesktop"),
        Path("C:\\Program Files\\GitHub Desktop"),
        Path("C:\\Program Files (x86)\\GitHub Desktop"),
    ]

    for path in common_paths:
        if path.exists() and (path / "GitHubDesktop.exe").exists():
            return path

    return None


def get_github_desktop_version() -> str | None:
    """Get the currently installed GitHub Desktop version"""
    install_dir = get_github_desktop_location()
    if not install_dir:
        return None

    # Try to find version in package.json or other version files
    version_files = [
        install_dir / "resources" / "app" / "package.json",
        install_dir / "package.json",
    ]

    for version_file in version_files:
        if version_file.exists():
            try:
                with open(version_file, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    return data.get("version", "Unknown")
            except (json.JSONDecodeError, KeyError):
                continue

    return "Unknown"


def get_github_desktop_download_info() -> dict:
    """Get the latest GitHub Desktop download information"""
    # GitHub Desktop releases API
    api_url = "https://api.github.com/repos/desktop/desktop/releases/latest"

    try:
        with httpx.Client(timeout=10.0) as client:
            response = client.get(api_url)
            response.raise_for_status()

            release_data = response.json()

            # Find Windows installer asset
            for asset in release_data.get("assets", []):
                if (
                    asset["name"].endswith(".exe")
                    and "windows" in asset["name"].lower()
                ):
                    return {
                        "version": release_data["tag_name"].lstrip("v"),
                        "download_url": asset["browser_download_url"],
                        "filename": asset["name"],
                        "size": asset["size"],
                    }

            # Fallback to direct URL if API doesn't work
            return {
                "version": "latest",
                "download_url": "https://central.github.com/deployments/desktop/desktop/latest/win32",
                "filename": "GitHubDesktop.exe",
                "size": 0,
            }

    except Exception:
        # Fallback to direct URL
        return {
            "version": "latest",
            "download_url": "https://central.github.com/deployments/desktop/desktop/latest/win32",
            "filename": "GitHubDesktop.exe",
            "size": 0,
        }


def download_file_with_progress(url: str, destination: Path) -> bool:
    """Download file from URL to destination with progress bar"""
    try:
        with httpx.stream("GET", url, follow_redirects=True, timeout=30.0) as response:
            response.raise_for_status()

            total_size = int(response.headers.get("content-length", 0))

            with Progress(
                SpinnerColumn(),
                TextColumn("[progress.description]{task.description}"),
                BarColumn(),
                DownloadColumn(),
                TransferSpeedColumn(),
                console=console,
            ) as progress:
                download_task = progress.add_task(
                    f"Downloading {destination.name}", total=total_size
                )

                with open(destination, "wb") as f:
                    for chunk in response.iter_bytes(chunk_size=8192):
                        f.write(chunk)
                        progress.update(download_task, advance=len(chunk))

        console.print(f"✅ Downloaded: {destination.name}", style="green")
        return True

    except httpx.HTTPError as e:
        console.print(f"❌ HTTP error: {e}", style="red")
        console.print(f"[dim]Failed to download from: {url}[/dim]", style="red")
        return False
    except Exception as e:
        console.print(f"❌ Download failed: {e}", style="red")
        return False


def install_github_desktop(installer_path: Path) -> int:
    """Install GitHub Desktop using the installer"""
    console.print("🔧 Installing GitHub Desktop...", style="yellow")

    try:
        with console.status(
            "[yellow]Installing GitHub Desktop... This may take a few minutes"
        ):
            # GitHub Desktop installer is typically a silent installer
            result = subprocess.run([str(installer_path)], check=False, timeout=300)

        return result.returncode

    except subprocess.TimeoutExpired:
        console.print("❌ Installation timed out after 5 minutes", style="red")
        return 1
    except Exception as e:
        console.print(f"❌ Installation failed: {e}", style="red")
        return 1


@app.command()
def download(
    output_dir: str = typer.Option(".", "--output", "-o", help="Output directory"),
    force: bool = typer.Option(False, "--force", help="Overwrite existing file"),
):
    """Download GitHub Desktop installer"""

    console.print(Panel.fit("📥 GitHub Desktop Downloader", style="bold cyan"))

    output_path = Path(output_dir)
    if not output_path.exists():
        console.print(f"❌ Output directory does not exist: {output_path}", style="red")
        raise typer.Exit(1)

    # Get download information
    console.print("🔍 Getting latest version info...", style="cyan")
    download_info = get_github_desktop_download_info()

    installer_path = output_path / download_info["filename"]

    # Check if file already exists
    if installer_path.exists() and not force:
        console.print(f"⚠️  File already exists: {installer_path}", style="yellow")
        if not Confirm.ask("Do you want to overwrite it?"):
            console.print("Download cancelled.", style="blue")
            return

    # Download the installer
    console.print(
        f"📥 Downloading GitHub Desktop {download_info['version']}...", style="cyan"
    )
    console.print(f"[dim]URL: {download_info['download_url']}[/dim]")
    console.print(f"[dim]Output: {installer_path}[/dim]")

    if download_file_with_progress(download_info["download_url"], installer_path):
        console.print(
            "✅ Successfully downloaded GitHub Desktop installer", style="green"
        )
        console.print(f"📂 Saved to: [green]{installer_path}[/green]")
        console.print(
            f"💡 Run '{SCRIPT_NAME} install --installer-path \"{installer_path}\"' to install",
            style="blue",
        )
    else:
        raise typer.Exit(1)


@app.command()
def install(
    installer_path: str | None = typer.Option(
        None, "--installer-path", help="Path to existing installer file"
    ),
    force: bool = typer.Option(
        False, "--force", help="Force reinstall even if GitHub Desktop exists"
    ),
):
    """Install GitHub Desktop"""

    console.print(Panel.fit("🚀 GitHub Desktop Installer", style="bold blue"))

    # Check if GitHub Desktop is already installed
    if check_github_desktop_installed() and not force:
        current_version = get_github_desktop_version()
        console.print("⚠️  GitHub Desktop is already installed!", style="yellow")
        if current_version:
            console.print(f"📦 Current version: [yellow]{current_version}[/yellow]")

        if not Confirm.ask("Do you want to continue anyway?"):
            console.print("Installation cancelled.", style="blue")
            return

    try:
        if installer_path:
            # Use existing installer
            installer_file = Path(installer_path)
            if not installer_file.exists():
                console.print(
                    f"❌ Installer file not found: {installer_file}", style="red"
                )
                raise typer.Exit(1)

            console.print(
                f"📦 Using existing installer: [green]{installer_file}[/green]"
            )
        else:
            # Download installer
            with tempfile.TemporaryDirectory(
                prefix="github_desktop_installer_"
            ) as temp_dir_str:
                temp_dir = Path(temp_dir_str)

                console.print(f"[dim]Using temporary directory: {temp_dir}[/dim]")

                # Get download information
                console.print("🔍 Getting latest version info...", style="cyan")
                download_info = get_github_desktop_download_info()

                installer_file = temp_dir / download_info["filename"]

                console.print(
                    f"📥 Downloading GitHub Desktop {download_info['version']}...",
                    style="cyan",
                )
                if not download_file_with_progress(
                    download_info["download_url"], installer_file
                ):
                    raise typer.Exit(1)

        # Display installation info
        content = f"Installer: [green]{installer_file}[/green]"

        config_panel = Panel(
            content,
            title="📋 Installation Configuration",
            title_align="left",
        )
        console.print(config_panel)

        # Install GitHub Desktop
        exit_code = install_github_desktop(installer_file)

        # Handle results
        if exit_code == 0:
            console.print(
                "✅ GitHub Desktop installation completed successfully!", style="green"
            )

            # Verify installation
            if check_github_desktop_installed():
                new_version = get_github_desktop_version()
                if new_version:
                    console.print(
                        f"🎉 Verified: GitHub Desktop version [green]{new_version}[/green] is installed"
                    )
                else:
                    console.print(
                        "🎉 Verified: GitHub Desktop is installed", style="green"
                    )
            else:
                console.print(
                    "⚠️  Installation completed but verification failed", style="yellow"
                )
        else:
            console.print(
                f"❌ Installation failed with exit code: {exit_code}", style="red"
            )
            raise typer.Exit(1)

    except KeyboardInterrupt:
        console.print("\n❌ Installation cancelled by user", style="red")
        raise typer.Exit(1)
    except Exception as e:
        console.print(f"❌ An unexpected error occurred: {e}", style="red")
        raise typer.Exit(1)


@app.command()
def uninstall(
    force: bool = typer.Option(False, "--force", help="Skip confirmation prompts"),
):
    """Uninstall GitHub Desktop"""

    console.print(Panel.fit("🗑️ GitHub Desktop Uninstaller", style="bold red"))

    # Check if GitHub Desktop is installed
    if not check_github_desktop_installed():
        console.print("❌ GitHub Desktop is not installed", style="red")
        return

    current_version = get_github_desktop_version()
    if current_version:
        console.print(
            f"📦 Found GitHub Desktop version: [yellow]{current_version}[/yellow]"
        )

    # GitHub Desktop typically installs its own uninstaller
    install_dir = get_github_desktop_location()
    if not install_dir:
        console.print(
            "❌ Could not find GitHub Desktop installation directory", style="red"
        )
        raise typer.Exit(1)

    # Look for uninstaller
    uninstaller_patterns = ["Uninstall*.exe", "uninstall.exe"]
    uninstaller = None

    for pattern in uninstaller_patterns:
        for candidate in install_dir.glob(pattern):
            uninstaller = candidate
            break
        if uninstaller:
            break

    if not uninstaller:
        console.print("❌ Could not find GitHub Desktop uninstaller", style="red")
        console.print("💡 Try manual uninstall through Windows Settings", style="blue")
        raise typer.Exit(1)

    console.print(f"🔍 Found uninstaller: [dim]{uninstaller}[/dim]")

    # Confirmation
    if not force:
        if not Confirm.ask("Are you sure you want to uninstall GitHub Desktop?"):
            console.print("Uninstall cancelled.", style="blue")
            return

    # Run uninstaller
    console.print("🗑️ Uninstalling GitHub Desktop...", style="yellow")

    try:
        with console.status("[yellow]Uninstalling GitHub Desktop..."):
            result = subprocess.run([str(uninstaller), "/S"], check=False, timeout=120)

        if result.returncode == 0:
            console.print("✅ GitHub Desktop uninstalled successfully!", style="green")

            # Verify uninstallation
            if not check_github_desktop_installed():
                console.print(
                    "🎉 Verified: GitHub Desktop has been removed", style="green"
                )
            else:
                console.print(
                    "⚠️ GitHub Desktop may still be present - restart may be required",
                    style="yellow",
                )
        else:
            console.print(
                f"❌ Uninstall failed with exit code: {result.returncode}", style="red"
            )
            raise typer.Exit(1)

    except subprocess.TimeoutExpired:
        console.print("❌ Uninstall timed out", style="red")
        raise typer.Exit(1)
    except Exception as e:
        console.print(f"❌ Uninstall failed: {e}", style="red")
        raise typer.Exit(1)


@app.command()
def check():
    """Check if GitHub Desktop is installed and show version info"""
    console.print("🔍 Checking GitHub Desktop installation...", style="cyan")

    if check_github_desktop_installed():
        version = get_github_desktop_version()
        install_location = get_github_desktop_location()

        console.print("✅ GitHub Desktop is installed", style="green")
        if version:
            console.print(f"📦 Version: [green]{version}[/green]")
        if install_location:
            console.print(f"📂 Location: [dim]{install_location}[/dim]")

        console.print("\n💡 Available actions:", style="blue")
        console.print(
            f"   • '{SCRIPT_NAME} install --force' - Reinstall GitHub Desktop",
            style="dim",
        )
        console.print(
            f"   • '{SCRIPT_NAME} uninstall' - Remove GitHub Desktop", style="dim"
        )
    else:
        console.print("❌ GitHub Desktop is not installed", style="red")
        console.print(
            f"💡 Run '{SCRIPT_NAME} install' to install GitHub Desktop", style="blue"
        )
        console.print(
            f"💡 Run '{SCRIPT_NAME} download' to download installer only", style="blue"
        )


@app.command()
def info():
    """Show information about GitHub Desktop"""
    console.print(Panel.fit("📋 GitHub Desktop Information", style="cyan bold"))

    # Get latest version info
    console.print("🔍 Getting latest version info...", style="cyan")
    download_info = get_github_desktop_download_info()

    info_text = f"""[bold]Latest Version:[/bold] {download_info["version"]}
[bold]Download URL:[/bold] {download_info["download_url"]}
[bold]Installer Name:[/bold] {download_info["filename"]}"""

    if download_info["size"] > 0:
        size_mb = download_info["size"] / (1024 * 1024)
        info_text += f"\n[bold]File Size:[/bold] {size_mb:.1f} MB"

    console.print(Panel(info_text, border_style="dim"))

    console.print(
        "\n💡 GitHub Desktop is a Git client with graphical interface", style="blue"
    )


if __name__ == "__main__":
    app()
