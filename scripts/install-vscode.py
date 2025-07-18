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
VS Code installer script that downloads and installs Visual Studio Code for Windows
"""

import os
import subprocess
from pathlib import Path
import tempfile
import time

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

# Default extensions to install
DEFAULT_EXTENSIONS = [
    "KnisterPeter.vscode-github",
    "ms-python.python",
    "ms-python.pylint",
    "ms-python.black-formatter",
    "ms-vscode.vscode-typescript-next",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
]


def check_vscode_installed() -> bool:
    """Check if VS Code is already installed"""
    try:
        # Check for VS Code in common installation paths
        username = os.environ.get("USERNAME", os.environ.get("USER", "User"))
        common_paths = [
            Path(
                f"C:\\Users\\{username}\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe"
            ),
            Path("C:\\Program Files\\Microsoft VS Code\\Code.exe"),
            Path("C:\\Program Files (x86)\\Microsoft VS Code\\Code.exe"),
        ]

        for path in common_paths:
            if path.exists():
                return True

        # Try to run code to check if it's in PATH
        result = subprocess.run(
            ["code", "--version"],
            capture_output=True,
            text=True,
            check=False,
            timeout=5,
        )
        return result.returncode == 0
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False


def get_vscode_location() -> Path | None:
    """Get the VS Code installation directory"""
    username = os.environ.get("USERNAME", os.environ.get("USER", "User"))
    common_paths = [
        Path(f"C:\\Users\\{username}\\AppData\\Local\\Programs\\Microsoft VS Code"),
        Path("C:\\Program Files\\Microsoft VS Code"),
        Path("C:\\Program Files (x86)\\Microsoft VS Code"),
    ]

    for path in common_paths:
        if path.exists() and (path / "Code.exe").exists():
            return path

    return None


def get_vscode_version() -> str | None:
    """Get the currently installed VS Code version"""
    try:
        result = subprocess.run(
            ["code", "--version"],
            capture_output=True,
            text=True,
            check=False,
            timeout=5,
        )
        if result.returncode == 0:
            lines = result.stdout.strip().split("\n")
            if lines:
                return lines[0]  # First line is the version
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass

    return None


def get_vscode_download_info() -> dict:
    """Get the VS Code download information"""
    # VS Code direct download URLs
    return {
        "version": "latest",
        "download_url": "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user",
        "filename": "VSCodeSetup.exe",
        "size": 0,  # Size not easily available from direct download
    }


def download_file_with_progress(url: str, destination: Path) -> bool:
    """Download file from URL to destination with progress bar"""
    try:
        with httpx.stream("GET", url, follow_redirects=True, timeout=60.0) as response:
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


def install_vscode(installer_path: Path) -> int:
    """Install VS Code using the installer"""
    console.print("🔧 Installing VS Code...", style="yellow")

    try:
        with console.status(
            "[yellow]Installing VS Code... This may take a few minutes"
        ):
            # VS Code installer with silent installation and useful options
            result = subprocess.run(
                [
                    str(installer_path),
                    "/NORESTART",
                    "/VERYSILENT",
                    "/MERGETASKS=addcontextmenufolders,addcontextmenufiles,quicklaunchicon,desktopicon,addtopath,!runcode",
                ],
                check=False,
                timeout=300,
            )

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
    """Download VS Code installer"""

    console.print(Panel.fit("📥 VS Code Downloader", style="bold cyan"))

    output_path = Path(output_dir)
    if not output_path.exists():
        console.print(f"❌ Output directory does not exist: {output_path}", style="red")
        raise typer.Exit(1)

    # Get download information
    console.print("🔍 Getting download info...", style="cyan")
    download_info = get_vscode_download_info()

    installer_path = output_path / download_info["filename"]

    # Check if file already exists
    if installer_path.exists() and not force:
        console.print(f"⚠️  File already exists: {installer_path}", style="yellow")
        if not Confirm.ask("Do you want to overwrite it?"):
            console.print("Download cancelled.", style="blue")
            return

    # Download the installer
    console.print(f"📥 Downloading VS Code {download_info['version']}...", style="cyan")
    console.print(f"[dim]URL: {download_info['download_url']}[/dim]")
    console.print(f"[dim]Output: {installer_path}[/dim]")

    if download_file_with_progress(download_info["download_url"], installer_path):
        console.print("✅ Successfully downloaded VS Code installer", style="green")
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
        False, "--force", help="Force reinstall even if VS Code exists"
    ),
):
    """Install VS Code"""

    console.print(Panel.fit("🚀 VS Code Installer", style="bold blue"))

    # Check if VS Code is already installed
    if check_vscode_installed() and not force:
        current_version = get_vscode_version()
        console.print("⚠️  VS Code is already installed!", style="yellow")
        if current_version:
            console.print(f"📦 Current version: [yellow]{current_version}[/yellow]")

        if not Confirm.ask("Do you want to continue anyway?"):
            console.print("Installation cancelled.", style="blue")
            return

    with tempfile.TemporaryDirectory(prefix="vscode_installer_") as temp_dir_str:
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
            temp_dir = Path(temp_dir_str)

            console.print(f"[dim]Using temporary directory: {temp_dir}[/dim]")

            # Get download information
            console.print("🔍 Getting download info...", style="cyan")
            download_info = get_vscode_download_info()

            installer_file = temp_dir / download_info["filename"]

            console.print(
                f"📥 Downloading VS Code {download_info['version']}...", style="cyan"
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

        # Install VS Code
        exit_code = install_vscode(installer_file)

        # Handle results
        if exit_code == 0:
            console.print(
                "✅ VS Code installation completed successfully!", style="green"
            )

            # Wait a moment for VS Code to be fully available
            time.sleep(2)

            # Verify installation
            if check_vscode_installed():
                new_version = get_vscode_version()
                if new_version:
                    console.print(
                        f"🎉 Verified: VS Code version [green]{new_version}[/green] is installed"
                    )
                else:
                    console.print("🎉 Verified: VS Code is installed", style="green")

            else:
                console.print(
                    "⚠️  Installation completed but verification failed", style="yellow"
                )
        else:
            console.print(
                f"❌ Installation failed with exit code: {exit_code}", style="red"
            )
            raise typer.Exit(1)


@app.command()
def install_extensions(
    install: bool = typer.Option(True, "--install", help="Install default extensions"),
):
    """Install default extensions in VS Code"""
    if not check_vscode_installed():
        console.print("❌ VS Code must be installed to manage extensions.", style="red")
        raise typer.Exit(1)

    if install:
        console.print("🔌 Installing default extensions...", style="cyan")
        for ext in DEFAULT_EXTENSIONS:
            result = subprocess.run(
                ["code", "--install-extension", ext], capture_output=True, text=True
            )
            if result.returncode == 0:
                console.print(f"✅ Installed: [green]{ext}[/green]")
            else:
                console.print(f"❌ Failed to install: [red]{ext}[/red]")
                console.print(f"[dim]{result.stderr.strip()}[/dim]")


@app.command()
def check():
    """Check if VS Code is installed and show version info"""
    console.print("🔍 Checking VS Code installation...", style="cyan")

    if check_vscode_installed():
        version = get_vscode_version()
        install_location = get_vscode_location()

        console.print("✅ VS Code is installed", style="green")
        if version:
            console.print(f"📦 Version: [green]{version}[/green]")
        if install_location:
            console.print(f"📂 Location: [dim]{install_location}[/dim]")

        console.print("\n💡 Available actions:", style="blue")
        console.print(
            f"   • '{SCRIPT_NAME} install --force' - Reinstall VS Code", style="dim"
        )
        console.print(f"   • '{SCRIPT_NAME} uninstall' - Remove VS Code", style="dim")
        console.print(
            f"   • '{SCRIPT_NAME} extensions --list' - List installed extensions",
            style="dim",
        )
    else:
        console.print("❌ VS Code is not installed", style="red")
        console.print(
            f"💡 Run '{SCRIPT_NAME} install' to install VS Code", style="blue"
        )
        console.print(
            f"💡 Run '{SCRIPT_NAME} download' to download installer only", style="blue"
        )


@app.command()
def info():
    """Show information about VS Code"""
    console.print(Panel.fit("📋 VS Code Information", style="cyan bold"))

    download_info = get_vscode_download_info()

    info_text = f"""[bold]Version:[/bold] {download_info["version"]}
[bold]Download URL:[/bold] {download_info["download_url"]}
[bold]Installer Name:[/bold] {download_info["filename"]}
"""

    console.print(Panel(info_text, border_style="dim"))


if __name__ == "__main__":
    app()
