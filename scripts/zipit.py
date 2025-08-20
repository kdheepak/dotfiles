# /// script
# requires-python = ">=3.11"
# dependencies = ["typer", "rich"]
# ///

import os
import subprocess
import zipfile
import sys
from pathlib import Path
from datetime import datetime
import typer
from rich.console import Console
from rich.progress import Progress

app = typer.Typer(add_completion=False)
console = Console()


def make_output_filename(base: str) -> str:
    """Append date (YYYYMMDD) to output filename before extension."""
    date = datetime.now().strftime("%Y%m%d")
    base_path = Path(base)
    if base_path.suffix:
        return f"{base_path.stem}-{date}{base_path.suffix}"
    else:
        return f"{base}-{date}.zip"


def confirm_overwrite(path: Path) -> bool:
    """Ask user before overwriting existing file."""
    if path.exists():
        console.print(f"[yellow]⚠️ File {path} already exists.[/]")
        response = input("Overwrite? [y/N]: ").strip().lower()
        return response == "y"
    return True


def zip_non_git_repo(output_file: str):
    files_to_zip = []
    for root, _, files in os.walk("."):
        if ".git" in root.split(os.sep):
            continue
        for file in files:
            filepath = Path(root) / file
            files_to_zip.append(filepath)

    with zipfile.ZipFile(output_file, "w", zipfile.ZIP_DEFLATED) as zipf, Progress(
        console=console
    ) as progress:
        task = progress.add_task(
            "[cyan]Zipping non-git files...", total=len(files_to_zip)
        )
        for filepath in files_to_zip:
            zipf.write(filepath, filepath.relative_to("."))
            progress.update(task, advance=1)

    console.print(f"[green]✅ Zipped all files (non-git) → {output_file}[/]")


def zip_git_repo(output_file: str):
    try:
        result = subprocess.run(
            ["git", "ls-files"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,
            check=True,
        )
        files = [Path(f) for f in result.stdout.splitlines()]
    except subprocess.CalledProcessError as e:
        console.print(f"[red]❌ Error running git:[/] {e.stderr}")
        sys.exit(1)

    with zipfile.ZipFile(output_file, "w", zipfile.ZIP_DEFLATED) as zipf, Progress(
        console=console
    ) as progress:
        task = progress.add_task("[cyan]Zipping git-tracked files...", total=len(files))
        for filepath in files:
            if filepath.exists():
                zipf.write(filepath, filepath)
            progress.update(task, advance=1)

    console.print(f"[green]✅ Zipped git-tracked files → {output_file}[/]")


@app.command()
def main(
    output: str = typer.Option(
        "archive.zip", "--output", "-o", help="Base name of the output zip file"
    ),
):
    """
    Zip the current directory.

    - If it's a git repo → only git-tracked files.
    - Otherwise → all files (excluding .git).
    - The output filename always has today's date suffix.
    """
    output_file = Path(make_output_filename(output))

    if not confirm_overwrite(output_file):
        console.print("[red]❌ Aborted — not overwriting.[/]")
        raise typer.Exit(code=1)

    if (Path(".") / ".git").exists():
        console.print("[bold blue]📦 Detected git repo[/]")
        zip_git_repo(str(output_file))
    else:
        console.print("[bold yellow]📦 Not a git repo — zipping all files[/]")
        zip_non_git_repo(str(output_file))


if __name__ == "__main__":
    app()
