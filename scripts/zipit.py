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

app = typer.Typer(add_completion=False)
console = Console()


def project_name() -> str:
    """Return the current folder name as project name."""
    return Path.cwd().name


def make_output_filename(base: str | None, fmt: str) -> Path:
    """Make output filename with date suffix (YYYYMMDD)."""
    date = datetime.now().strftime("%Y%m%d")
    if base is None:
        base = f"{project_name()}.{fmt}"
    base_path = Path(base)
    suffix = base_path.suffix or f".{fmt}"
    return Path(f"{base_path.stem}-{date}{suffix}")


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


def archive_zip(files: list[Path], output_file: Path):
    total_size = sum(f.stat().st_size for f in files if f.exists())

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

            for i, filepath in enumerate(files, 1):
                if filepath.exists():
                    # Update description to show current file
                    progress.update(
                        task, description=f"[cyan]Adding {filepath} ({i}/{len(files)})"
                    )
                    zipf.write(filepath, filepath)
                    progress.update(task, advance=1)
                else:
                    progress.update(task, advance=1)

    return total_size, output_file.stat().st_size


def archive_tar(files: list[Path], output_file: Path):
    total_size = sum(f.stat().st_size for f in files if f.exists())

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

            for i, filepath in enumerate(files, 1):
                if filepath.exists():
                    # Update description to show current file
                    progress.update(
                        task, description=f"[cyan]Adding {filepath} ({i}/{len(files)})"
                    )
                    tarf.add(filepath, arcname=filepath)
                    progress.update(task, advance=1)
                else:
                    progress.update(task, advance=1)

    return total_size, output_file.stat().st_size


def archive_7z(files: list[Path], output_file: Path):
    if not shutil.which("7z"):
        console.print(
            "[red]❌ 7z not found. Please install it and ensure it's in PATH.[/]"
        )
        sys.exit(1)

    total_size = sum(f.stat().st_size for f in files if f.exists())

    # For 7z, we'll show progress by adding files in batches
    # since we can't easily show individual file progress with subprocess
    with Progress(
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
        TimeRemainingColumn(),
        console=console,
        transient=False,
    ) as progress:
        task = progress.add_task("[cyan]Creating 7Z archive", total=100)

        # Show preparation step
        progress.update(task, description="[cyan]Preparing 7z command...")
        progress.update(task, advance=10)

        cmd = ["7z", "a", "-y", str(output_file)] + [str(f) for f in files]

        # Show compression step
        progress.update(
            task, description=f"[cyan]Compressing {len(files)} files with 7z..."
        )
        progress.update(task, advance=70)

        subprocess.run(cmd, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        # Complete
        progress.update(task, description="[cyan]7z compression complete")
        progress.update(task, advance=20)

    return total_size, output_file.stat().st_size


def show_summary(
    files: list[Path], total_size: int, compressed_size: int, output_file: Path
):
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


def get_git_files(use_archive: bool) -> list[Path]:
    if use_archive:
        tmpfile = Path(".git") / "tmp_archive.zip"
        try:
            subprocess.run(
                ["git", "archive", "--format=zip", "HEAD", "-o", str(tmpfile)],
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
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
        )
        return [Path(f) for f in result.stdout.splitlines()]
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Error running git ls-files:[/] {e.stderr}")
        sys.exit(1)


def get_non_git_files() -> list[Path]:
    files = []
    for root, _, filenames in os.walk("."):
        if ".git" in root.split(os.sep):
            continue
        for file in filenames:
            files.append(Path(root) / file)
    return [f.relative_to(".") for f in files]


@app.command()
def main(
    output: str = typer.Option(
        None, "--output", "-o", help="Base name of the output archive"
    ),
    fmt: str = typer.Option(
        "zip", "--format", "-f", help="Archive format: zip | tar.gz | 7z"
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
):
    """
    Archive the current directory.
    """
    if fmt not in {"zip", "tar.gz", "7z"}:
        console.print("[red]❌ Unsupported format. Use zip, tar.gz, or 7z.[/]")
        raise typer.Exit(code=1)

    output_file = make_output_filename(output, fmt)

    if not confirm_overwrite(output_file, force, no_overwrite):
        raise typer.Exit(code=1)

    if git_files and (Path(".") / ".git").exists():
        console.print("[bold blue]📦 Using git-tracked files[/]")
        files = get_git_files(use_git_archive)
    else:
        console.print("[bold yellow]📦 Archiving all files[/]")
        files = get_non_git_files()

    files = filter_files(files, includes=include or [], excludes=exclude or [])

    if not files:
        console.print("[red]❌ No files matched your filters.[/]")
        raise typer.Exit(code=1)

    console.print(f"[bold green]✨ Found {len(files)} files to archive[/]")

    if fmt == "zip":
        total, compressed = archive_zip(files, output_file)
    elif fmt == "tar.gz":
        total, compressed = archive_tar(files, output_file)
    else:
        total, compressed = archive_7z(files, output_file)

    show_summary(files, total, compressed, output_file)


if __name__ == "__main__":
    app()
