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
Git installer script that downloads and installs Git for Windows
"""

import os
import subprocess
from pathlib import Path
import tempfile

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


def get_default_config(
    version: str = "2.50.0", editor: str = "VisualStudioCode"
) -> dict[str, str]:
    """Get default Git installation configuration"""
    username = os.environ.get("USERNAME", os.environ.get("USER", "User"))

    return {
        "version": version,
        "install_dir": f"C:\\Users\\{username}\\AppData\\Local\\Programs\\Git",
        "editor": editor,
        "default_branch": "main",
        "components": "icons,icons\\desktop,icons\\quicklaunch,ext,ext\\shellhere,ext\\guihere,gitlfs,assoc,assoc_sh,autoupdate,windowsterminal",
        "setup_type": "default",
        "path_option": "Cmd",
        "ssh_option": "OpenSSH",
        "curl_option": "OpenSSL",
        "crlf_option": "LFOnly",
        "bash_terminal": "MinTTY",
        "pull_behavior": "Rebase",
        "credential_manager": "Enabled",
        "performance_tweaks": "Enabled",
        "enable_symlinks": "Enabled",
        "enable_pseudo_console": "Enabled",
        "enable_fs_monitor": "Enabled",
    }


def check_git_installed() -> bool:
    """Check if Git is already installed"""
    try:
        result = subprocess.run(
            ["git", "--version"],
            capture_output=True,
            text=True,
            check=False,
            timeout=10,
        )
        return result.returncode == 0
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return False


def get_git_download_url(version: str) -> str:
    """Get the download URL for a specific Git version"""
    return f"https://github.com/git-for-windows/git/releases/download/v{version}.windows.1/Git-{version}-64-bit.exe"


def get_installer_filename(version: str) -> str:
    """Get the installer filename for a specific Git version"""
    return f"Git-{version}-64-bit.exe"


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


def create_git_config(temp_dir: Path, config: dict[str, str]) -> Path:
    """Create Git installation configuration file"""
    config_content = f"""[Setup]
Dir={config["install_dir"]}
Group=Git
NoIcons=0
SetupType={config["setup_type"]}
Components={config["components"]}
Tasks=
EditorOption={config["editor"]}
DefaultBranchOption={config["default_branch"]}
PathOption={config["path_option"]}
SSHOption={config["ssh_option"]}
TortoiseOption=false
CURLOption={config["curl_option"]}
CRLFOption={config["crlf_option"]}
BashTerminalOption={config["bash_terminal"]}
GitPullBehaviorOption={config["pull_behavior"]}
UseCredentialManager={config["credential_manager"]}
PerformanceTweaksFSCache={config["performance_tweaks"]}
EnableSymlinks={config["enable_symlinks"]}
EnablePseudoConsoleSupport={config["enable_pseudo_console"]}
EnableFSMonitor={config["enable_fs_monitor"]}
"""

    config_path = temp_dir / "git.info"
    config_path.write_text(config_content, encoding="utf-8")

    console.print(f"[dim]Created config file: {config_path}[/dim]")
    return config_path


def install_git_from_installer(installer_path: Path, config_path: Path) -> int:
    """Install Git using the installer and configuration"""
    console.print("🔧 Installing Git...", style="yellow")

    try:
        with console.status("[yellow]Installing Git... This may take a few minutes"):
            result = subprocess.run(
                [
                    str(installer_path),
                    "/VERYSILENT",
                    "/NORESTART",
                    "/NOCANCEL",
                    f"/LOADINF={config_path}",
                    "/RESTARTEXITCODE=3",
                ],
                check=False,
                timeout=300,
            )  # 5 minute timeout

        return result.returncode

    except subprocess.TimeoutExpired:
        console.print("❌ Installation timed out after 5 minutes", style="red")
        return 1
    except Exception as e:
        console.print(f"❌ Installation failed: {e}", style="red")
        return 1


@app.command()
def download(
    version: str = typer.Option("2.50.0", "--version", help="Git version to download"),
    output_dir: str = typer.Option(
        Path("."), "--output", help="Output directory", exists=True, file_okay=False
    ),
    force: bool = typer.Option(False, "--force", help="Overwrite existing file"),
):
    """Download Git installer for Windows"""

    console.print(Panel.fit("📥 Git Downloader", style="bold cyan"))

    output_path = Path(output_dir)
    if not output_path.exists():
        console.print(f"❌ Output directory does not exist: {output_path}", style="red")
        raise typer.Exit(1)

    installer_filename = get_installer_filename(version)
    installer_path = output_path / installer_filename

    # Check if file already exists
    if installer_path.exists() and not force:
        console.print(f"⚠️  File already exists: {installer_path}", style="yellow")
        if not Confirm.ask("Do you want to overwrite it?"):
            console.print("Download cancelled.", style="blue")
            return

    # Download the installer
    git_url = get_git_download_url(version)

    console.print(f"📥 Downloading Git {version}...", style="cyan")
    console.print(f"[dim]URL: {git_url}[/dim]")
    console.print(f"[dim]Output: {installer_path}[/dim]")

    if download_file_with_progress(git_url, installer_path):
        console.print(
            f"✅ Successfully downloaded Git {version} installer", style="green"
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
    version: str = typer.Option("2.50.0", "--version", help="Git version to install"),
    editor: str = typer.Option("VisualStudioCode", "--editor", help="Default editor"),
    install_dir: str | None = typer.Option(
        None, "--install-dir", help="Custom installation directory"
    ),
    installer_path: str | None = typer.Option(
        None, "--installer-path", help="Path to existing installer file"
    ),
    force: bool = typer.Option(
        False, "--force", help="Force reinstall even if Git exists"
    ),
    default_branch: str = typer.Option(
        "main", "--default-branch", help="Default branch name"
    ),
    include_desktop_icon: bool = typer.Option(
        True, "--desktop-icon/--no-desktop-icon", help="Include desktop icon"
    ),
):
    """Install Git for Windows"""

    console.print(Panel.fit("🚀 Git Installer for Windows", style="bold blue"))

    # Create configuration
    config = get_default_config(version, editor)
    config["default_branch"] = default_branch

    if install_dir:
        config["install_dir"] = install_dir

    if not include_desktop_icon:
        config["components"] = config["components"].replace("icons\\desktop,", "")

    # Check if Git is already installed
    if check_git_installed() and not force:
        console.print("⚠️  Git is already installed!", style="yellow")
        if not Confirm.ask("Do you want to continue anyway?"):
            console.print("Installation cancelled.", style="blue")
            return

    # Use temporary directory for installation
    with tempfile.TemporaryDirectory(prefix="git_installer_") as temp_dir_str:
        temp_dir = Path(temp_dir_str)

        console.print(f"[dim]Using temporary directory: {temp_dir}[/dim]")

        # Prepare installer (download or use existing)
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
            git_url = get_git_download_url(version)
            installer_file = temp_dir / get_installer_filename(version)

            console.print(f"📥 Downloading Git {version}...", style="cyan")
            if not download_file_with_progress(git_url, installer_file):
                raise typer.Exit(1)

        content = f"""
    Installer: [green]{installer_file}[/green]
    Version: [green]{config["version"]}[/green]
    Editor: [green]{config["editor"]}[/green]
    Install Dir: [green]{config["install_dir"]}[/green]
    Default Branch: [green]{config["default_branch"]}[/green]
    Desktop Icon: [green]{"Yes" if include_desktop_icon else "No"}[/green]
    """

        config_panel = Panel(
            content,
            title="📋 Installation Configuration",
            title_align="left",
        )
        console.print(config_panel)

        # Create configuration file
        console.print("⚙️  Creating installation configuration...", style="cyan")
        config_path = create_git_config(temp_dir, config)

        # Install Git
        exit_code = install_git_from_installer(installer_file, config_path)

        # Handle results
        if exit_code == 3:
            console.print(
                Panel(
                    "🔄 Installation complete! You must restart your machine to finish setup.",
                    style="yellow",
                )
            )
        elif exit_code == 0:
            console.print("✅ Git installation completed successfully!", style="green")

            # Verify installation
            if check_git_installed():
                result = subprocess.run(
                    ["git", "--version"], capture_output=True, text=True
                )
                console.print(f"🎉 Verified: [green]{result.stdout.strip()}[/green]")
            else:
                console.print(
                    "⚠️  Installation completed but Git verification failed",
                    style="yellow",
                )
        else:
            console.print(
                f"❌ Installation failed with exit code: {exit_code}", style="red"
            )
            raise typer.Exit(1)


@app.command()
def check():
    """Check if Git is installed and show version info"""
    console.print("🔍 Checking Git installation...", style="cyan")

    if check_git_installed():
        try:
            result = subprocess.run(
                ["git", "--version"], capture_output=True, text=True, timeout=5
            )
            console.print(
                f"✅ Git is installed: [green]{result.stdout.strip()}[/green]"
            )

            # Try to get install path
            try:
                where_result = subprocess.run(
                    ["where", "git"], capture_output=True, text=True, timeout=5
                )
                if where_result.returncode == 0:
                    git_path = where_result.stdout.strip().split("\n")[0]
                    console.print(f"📂 Location: [dim]{git_path}[/dim]")
            except Exception as _:
                pass

        except subprocess.TimeoutExpired:
            console.print(
                "✅ Git is installed but version check timed out", style="yellow"
            )
    else:
        console.print("❌ Git is not installed", style="red")
        console.print(f"💡 Run '{SCRIPT_NAME} install' to install Git", style="blue")


@app.command()
def config():
    """Show default configuration that will be used"""
    default_config = get_default_config()

    console.print(
        Panel.fit("📋 Default Git Installation Configuration", style="cyan bold")
    )

    config_text = ""
    for key, value in default_config.items():
        formatted_key = key.replace("_", " ").title()
        config_text += f"[bold]{formatted_key:<25}:[/bold] {value}\n"

    console.print(Panel(config_text.rstrip(), border_style="dim"))

    console.print(
        "\n💡 Use command line options to customize these settings", style="blue"
    )


if __name__ == "__main__":
    app()
