#!/usr/bin/env -S uv --quiet run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["typer", "rich"]
# ///

import os
import subprocess
import zipfile
import tarfile
import sys
import fnmatch
import shutil
from pathlib import Path
from datetime import datetime
import typer
from rich.console import Console
from rich.progress import (
    Progress,
    TextColumn,
    BarColumn,
    TaskProgressColumn,
    TimeRemainingColumn,
)
from rich.table import Table

app = typer.Typer(
    name=Path(__file__).stem,
    add_completion=False,
    no_args_is_help=True,
    rich_markup_mode="rich",
    pretty_exceptions_show_locals=False,
)
console = Console()


def project_name(folder: Path) -> str:
    """Return the folder name as project name."""
    return folder.name


def get_git_describe(folder: Path) -> str | None:
    """Get git describe output if available."""
    try:
        result = subprocess.run(
            [
                "git",
                "describe",
                "--tags",
                "--long",
                "--always",
                "--dirty",
                "--abbrev=7",
            ],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True,
            cwd=folder,
        )
        return result.stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None


def normalize_suffix(fmt: str) -> str:
    """Return the proper suffix for the archive format."""
    return ".tar.gz" if fmt == "tar.gz" else f".{fmt}"


def default_base_name(folder: Path, fmt: str) -> Path:
    """Generate a default base filename based on project + git describe."""
    project = project_name(folder)
    git_desc = get_git_describe(folder)
    if git_desc:
        return Path(f"{project}-{git_desc}{normalize_suffix(fmt)}")
    return Path(f"{project}{normalize_suffix(fmt)}")


def add_date_suffix(base: Path) -> Path:
    """Add today's date before the extension, unless already present."""
    date = datetime.now().strftime("%Y%m%d")
    return base.with_name(f"{base.stem}-{date}{base.suffix}")


def make_output_filename(base: str | None, fmt: str, folder: Path) -> Path:
    """Return the output filename, adding default name and date suffix if needed."""
    base_path = Path(base) if base else default_base_name(folder, fmt)
    return add_date_suffix(base_path)


def confirm_overwrite(path: Path, force: bool, no_overwrite: bool) -> bool:
    """Decide if we should overwrite a file based on flags or user input."""
    if not path.exists():
        return True
    if force:
        return True
    if no_overwrite:
        console.print(f"[red]❌ File {path} exists — not overwriting.[/]")
        return False

    console.print(f"[yellow]⚠️ File {path} already exists.[/]")
    response = input("Overwrite? [y/N]: ").strip().lower()
    return response == "y"


def filter_files(
    files: list[Path], includes: list[str], excludes: list[str]
) -> list[Path]:
    """Filter files with include/exclude patterns."""

    def matches_any(path: Path, patterns: list[str]) -> bool:
        return any(fnmatch.fnmatch(str(path), pat) for pat in patterns)

    if includes:
        files = [f for f in files if matches_any(f, includes)]
    if excludes:
        files = [f for f in files if not matches_any(f, excludes)]
    return files


def archive_zip(files: list[Path], output_file: Path, base_folder: Path):
    """Create a zip archive using Python's zipfile module."""
    total_size = sum(
        (base_folder / f).stat().st_size for f in files if (base_folder / f).exists()
    )

    with zipfile.ZipFile(output_file, "w", zipfile.ZIP_DEFLATED) as zipf:
        with Progress(
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
            TaskProgressColumn(),
            TimeRemainingColumn(),
            console=console,
            transient=False,
        ) as progress:
            task = progress.add_task("[cyan]Creating ZIP archive", total=len(files))

            for filepath in files:
                full_path = base_folder / filepath
                if full_path.exists():
                    console.print(f"  [dim cyan]Adding:[/] {filepath}")
                    progress.update(task, advance=1)
                    zipf.write(full_path, filepath)
                else:
                    progress.update(task, advance=1)

            progress.update(
                task, description=f"[green]ZIP archive created successfully"
            )

    return total_size, output_file.stat().st_size


def archive_tar(files: list[Path], output_file: Path, base_folder: Path):
    """Create a tar.gz archive using Python's tarfile module."""
    total_size = sum(
        (base_folder / f).stat().st_size for f in files if (base_folder / f).exists()
    )

    with tarfile.open(output_file, "w:gz") as tarf:
        with Progress(
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
            TaskProgressColumn(),
            TimeRemainingColumn(),
            console=console,
            transient=False,
        ) as progress:
            task = progress.add_task("[cyan]Creating TAR.GZ archive", total=len(files))

            for filepath in files:
                full_path = base_folder / filepath
                if full_path.exists():
                    console.print(f"  [dim cyan]Adding:[/] {filepath}")
                    progress.update(task, advance=1)
                    tarf.add(full_path, arcname=filepath)
                else:
                    progress.update(task, advance=1)

            progress.update(
                task, description=f"[green]TAR.GZ archive created successfully"
            )

    return total_size, output_file.stat().st_size


def archive_7z(files: list[Path], output_file: Path, base_folder: Path):
    """Create a 7z archive using the external 7z binary."""
    if not shutil.which("7z"):
        console.print(
            "[red]❌ 7z not found. Please install it and ensure it's in PATH.[/]"
        )
        sys.exit(1)

    total_size = sum(
        (base_folder / f).stat().st_size for f in files if (base_folder / f).exists()
    )

    with Progress(
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TimeRemainingColumn(),
        console=console,
        transient=False,
    ) as progress:
        task = progress.add_task("[cyan]Creating 7Z archive", total=100)
        abs_output = (
            output_file if output_file.is_absolute() else Path.cwd() / output_file
        )
        cmd = ["7z", "a", "-y", str(abs_output)] + [str(f) for f in files]

        progress.update(task, description="[cyan]Compressing with 7z...")
        subprocess.run(
            cmd,
            check=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            cwd=base_folder,
        )

        progress.update(task, description="[cyan]7z compression complete")
        progress.update(task, advance=100)

    return total_size, output_file.stat().st_size


def archive_with_ouch(
    files: list[Path], output_file: Path, base_folder: Path, fmt: str, extra: list[str]
):
    """Create an archive using ouch with the given format and extra options."""
    if not shutil.which("ouch"):
        console.print(
            "[red]❌ ouch not found. Please install it and ensure it's in PATH.[/]"
        )
        sys.exit(1)

    total_size = sum(
        (base_folder / f).stat().st_size for f in files if (base_folder / f).exists()
    )

    abs_output = output_file if output_file.is_absolute() else Path.cwd() / output_file
    cmd = (
        ["ouch", "compress"]
        + [str(base_folder / f) for f in files]
        + [str(abs_output), "--format", fmt]
        + extra
    )

    console.print(f"[cyan]▶ Running with ouch:[/] {' '.join(cmd)}")
    subprocess.run(cmd, check=True, cwd=base_folder)

    compressed_size = abs_output.stat().st_size if abs_output.exists() else 0
    return total_size, compressed_size


def show_summary(
    files: list[Path], total_size: int, compressed_size: int, output_file: Path
):
    """Display a summary table of the archive process."""
    table = Table(title="Archive Summary", show_lines=True)
    table.add_column("Metric", style="cyan")
    table.add_column("Value", style="green")
    table.add_row("Files", str(len(files)))
    table.add_row("Original Size", f"{total_size/1024:.2f} KB")
    table.add_row("Compressed Size", f"{compressed_size/1024:.2f} KB")
    table.add_row(
        "Compression Ratio",
        f"{(1 - compressed_size/total_size)*100:.1f}%" if total_size > 0 else "0%",
    )
    table.add_row("Output File", str(output_file))
    console.print(table)


def get_git_files(use_archive: bool, folder: Path) -> list[Path]:
    """Return git-tracked files using either ls-files or git archive."""
    if use_archive:
        tmpfile = folder / ".git" / "tmp_archive.zip"
        try:
            subprocess.run(
                ["git", "archive", "--format=zip", "HEAD", "-o", str(tmpfile)],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                cwd=folder,
            )
            with zipfile.ZipFile(tmpfile, "r") as zf:
                files = [Path(name) for name in zf.namelist()]
            tmpfile.unlink(missing_ok=True)
            return files
        except subprocess.CalledProcessError as e:
            console.print(f"[red]❌ git archive failed:[/] {e}")
            sys.exit(1)

    try:
        result = subprocess.run(
            ["git", "ls-files"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True,
            cwd=folder,
        )
        return [Path(f) for f in result.stdout.splitlines()]
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Error running git ls-files:[/] {e.stderr}")
        sys.exit(1)


def get_non_git_files(folder: Path) -> list[Path]:
    """Return all files under a folder, excluding .git/ directories."""
    files = []
    for root, _, filenames in os.walk(folder):
        if ".git" in Path(root).parts:
            continue
        for file in filenames:
            full_path = Path(root) / file
            relative_path = full_path.relative_to(folder)
            files.append(relative_path)
    return files


@app.command()
def main(
    folder: str = typer.Argument(
        ".", help="Directory to archive (defaults to current directory)"
    ),
    output: str = typer.Option(
        None, "--output", "-o", help="Base name of the output archive"
    ),
    fmt: str = typer.Option(
        "ouch:zip",
        "--format",
        "-f",
        help="Archive format. zip | tar.gz | 7z | ouch:<fmt>",
    ),
    include: list[str] = typer.Option(
        None, "--include", help="Glob pattern of files to include"
    ),
    exclude: list[str] = typer.Option(
        None, "--exclude", help="Glob pattern of files to exclude"
    ),
    git_files: bool = typer.Option(
        False, "--git-files", help="Only include git-tracked files"
    ),
    use_git_archive: bool = typer.Option(
        False,
        "--use-git-archive",
        help="Use `git archive` instead of ls-files (only if --git-files is set)",
    ),
    force: bool = typer.Option(False, "--force", help="Overwrite without asking"),
    no_overwrite: bool = typer.Option(
        False, "--no-overwrite", help="Do not overwrite existing files"
    ),
    ouch_options: list[str] = typer.Option(
        None,
        "--ouch-option",
        help="Extra options to pass to ouch (e.g. --ouch-option --threads=4)",
    ),
):
    """
    Archive a directory.

    Examples:
      zipit.py                    # Archive current directory (ouch:zip)
      zipit.py -f ouch:zst        # Use ouch with zstd format
      zipit.py -f tar.gz          # Use built-in tar.gz
      zipit.py ../my-project -f ouch:tar --ouch-option --threads=4
    """
    target_folder = Path(folder).resolve()
    if not target_folder.exists():
        console.print(f"[red]❌ Directory {target_folder} does not exist.[/]")
        raise typer.Exit(code=1)
    if not target_folder.is_dir():
        console.print(f"[red]❌ {target_folder} is not a directory.[/]")
        raise typer.Exit(code=1)
    console.print(f"[bold blue]📂 Archiving directory: {target_folder}[/]")

    # detect ouch usage (default)
    use_ouch = fmt.startswith("ouch:")
    real_fmt = fmt.split(":", 1)[1] if use_ouch else fmt

    output_file = make_output_filename(output, real_fmt, target_folder)

    if not confirm_overwrite(output_file, force, no_overwrite):
        raise typer.Exit(code=1)

    if git_files and (target_folder / ".git").exists():
        console.print("[bold blue]📦 Using git-tracked files[/]")
        files = get_git_files(use_git_archive, target_folder)
    else:
        console.print("[bold yellow]📦 Archiving all files[/]")
        files = get_non_git_files(target_folder)

    files = filter_files(files, includes=include or [], excludes=exclude or [])

    if not files:
        console.print("[red]❌ No files matched your filters.[/]")
        raise typer.Exit(code=1)

    console.print(f"[bold green]✨ Found {len(files)} files to archive[/]")

    if use_ouch:
        total, compressed = archive_with_ouch(
            files, output_file, target_folder, real_fmt, ouch_options or []
        )
    elif real_fmt == "zip":
        total, compressed = archive_zip(files, output_file, target_folder)
    elif real_fmt == "tar.gz":
        total, compressed = archive_tar(files, output_file, target_folder)
    elif real_fmt == "7z":
        total, compressed = archive_7z(files, output_file, target_folder)
    else:
        console.print("[red]❌ Unsupported format. Use zip, tar.gz, 7z, or ouch:<fmt>.")
        raise typer.Exit(code=1)

    show_summary(files, total, compressed, output_file)


if __name__ == "__main__":
    app()
