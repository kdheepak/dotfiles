# /// script
# requires-python = ">=3.11"
# dependencies = ["typer", "rich"]
# ///

import os
import subprocess
import zipfile
import sys
import fnmatch
from pathlib import Path
from datetime import datetime
import typer
from rich.console import Console
from rich.progress import Progress
from rich.table import Table

app = typer.Typer(add_completion=False)
console = Console()


def project_name() -> str:
    """Return the current folder name as project name."""
    return Path.cwd().name


def make_output_filename(base: str | None) -> Path:
    """Make output filename with date suffix (YYYYMMDD)."""
    date = datetime.now().strftime("%Y%m%d")
    if base is None:
        base = f"{project_name()}.zip"
    base_path = Path(base)
    if base_path.suffix:
        return Path(f"{base_path.stem}-{date}{base_path.suffix}")
    else:
        return Path(f"{base}-{date}.zip")


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


def zip_files(files: list[Path], output_file: Path):
    """Zip the given files and show progress + summary."""
    total_size = sum(f.stat().st_size for f in files if f.exists())

    with zipfile.ZipFile(output_file, "w", zipfile.ZIP_DEFLATED) as zipf, Progress(
        console=console
    ) as progress:
        task = progress.add_task("[cyan]Zipping files...", total=len(files))
        for filepath in files:
            if filepath.exists():
                zipf.write(filepath, filepath)
            progress.update(task, advance=1)

    compressed_size = output_file.stat().st_size if output_file.exists() else 0

    # Summary table
    table = Table(title="Archive Summary", show_lines=True)
    table.add_column("Metric", style="cyan")
    table.add_column("Value", style="green")
    table.add_row("Files", str(len(files)))
    table.add_row("Original Size", f"{total_size/1024:.2f} KB")
    table.add_row("Compressed Size", f"{compressed_size/1024:.2f} KB")
    table.add_row("Output File", str(output_file))
    console.print(table)


def get_git_files(use_archive: bool) -> list[Path]:
    """Return list of git-tracked files, or empty if error."""
    if use_archive:
        # git archive to a temp zip
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
    """Return all files except .git directory."""
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
        None, "--output", "-o", help="Base name of the output zip file"
    ),
    include: list[str] = typer.Option(
        None, "--include", help="Glob pattern of files to include"
    ),
    exclude: list[str] = typer.Option(
        None, "--exclude", help="Glob pattern of files to exclude"
    ),
    use_git_archive: bool = typer.Option(
        False, "--use-git-archive", help="Use `git archive` instead of ls-files"
    ),
    force: bool = typer.Option(False, "--force", help="Overwrite without asking"),
    no_overwrite: bool = typer.Option(
        False, "--no-overwrite", help="Do not overwrite existing files"
    ),
):
    """
    Zip the current directory.

    - If it's a git repo → only git-tracked files (or `git archive` if enabled).
    - Otherwise → all files (excluding .git).
    - The output filename always includes today's date with hyphen suffix.
    """
    output_file = make_output_filename(output)

    if not confirm_overwrite(output_file, force, no_overwrite):
        raise typer.Exit(code=1)

    if (Path(".") / ".git").exists():
        console.print("[bold blue]📦 Detected git repo[/]")
        files = get_git_files(use_git_archive)
    else:
        console.print("[bold yellow]📦 Not a git repo — zipping all files[/]")
        files = get_non_git_files()

    # Apply filters
    files = filter_files(files, includes=include or [], excludes=exclude or [])

    if not files:
        console.print("[red]❌ No files matched your filters.[/]")
        raise typer.Exit(code=1)

    zip_files(files, output_file)


if __name__ == "__main__":
    app()
