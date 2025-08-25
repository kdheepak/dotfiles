#!/usr/bin/env -S uv --quiet run --script
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "extract-msg",
#     "html2text",
#     "typer",
#     "rich",
# ]
# ///

import re
import extract_msg
import html2text
import typer
from rich.console import Console
from rich.progress import track
from pathlib import Path

console = Console()
app = typer.Typer(add_completion=False)


def sanitize_filename(name: str) -> str:
    """Remove invalid characters for filenames."""
    return re.sub(r"[^a-zA-Z0-9_.-]", "_", name).strip("_") or "untitled"


def clean_text(text: str) -> str:
    """Sanitize text to remove null bytes and non-printable characters."""
    # Remove null bytes
    text = text.replace("\x00", "")
    # Keep only printable characters and standard whitespace
    text = "".join(c for c in text if c.isprintable() or c in "\n\r\t")
    # Ensure UTF-8 encoding with replacement for invalid bytes
    return text.encode("utf-8", errors="replace").decode("utf-8")


def convert_msg_to_md(
    msg_path: Path,
    output_md: Path,
    assets_folder: Path = Path("assets"),
):
    # Load message
    msg = extract_msg.Message(str(msg_path))
    subject = msg.subject or "No Subject"
    sender = msg.sender or "Unknown Sender"
    date = msg.date or ""

    # Pick best body
    body = msg.body or msg.htmlBody or ""

    # Decode htmlBody if it's bytes
    if isinstance(msg.htmlBody, bytes):
        try:
            body = msg.htmlBody.decode("utf-8", errors="ignore")
        except Exception:
            body = msg.htmlBody.decode("latin-1", errors="ignore")

    # Remove null bytes early
    body = body.replace("\x00", "")

    # Ensure assets folder exists
    assets_folder.mkdir(parents=True, exist_ok=True)

    # Extract attachments
    attachment_links = {}
    for att in track(msg.attachments, description="Extracting attachments..."):
        filename = sanitize_filename(att.longFilename or att.shortFilename)
        if not filename:
            continue
        filepath = assets_folder / filename
        with open(filepath, "wb") as f:
            f.write(att.data)
        attachment_links[filename] = filepath

    # Replace inline images in HTML body (if HTML)
    if body and "<html" in body.lower():
        for cid, filepath in attachment_links.items():
            short_name = filepath.name
            body = re.sub(
                rf"cid:{re.escape(cid)}",
                f"./{assets_folder}/{short_name}",
                body,
            )

    # Convert HTML body (if available) to Markdown
    body = html2text.html2text(body)

    # Final cleanup: remove any remaining null bytes & non-printable characters line by line
    lines = [line.replace("\x00", "") for line in body.splitlines()]
    body = "\n".join(lines)
    body = clean_text(body)

    # Check if file exists and ask before overwriting
    if output_md.exists():
        overwrite = typer.confirm(
            f"File '{output_md.name}' already exists. Overwrite?", default=False
        )
        if not overwrite:
            console.print("[yellow]Aborted by user.[/yellow]")
            raise typer.Exit()

    # Write markdown file
    with open(output_md, "w", encoding="utf-8") as f:
        f.write(f"# {subject}\n\n")
        f.write(f"**From:** {sender}  \n")
        f.write(f"**Date:** {date}\n\n")
        f.write(body)

    console.print(f"✅ [green]Converted[/green] {msg_path} → {output_md}")


@app.command()
def main(
    msg_file: Path = typer.Argument(..., help="The Outlook .msg file to convert."),
    md_file: Path = typer.Option(
        None,
        "--output",
        "-o",
        help="Output markdown file (default: sanitized subject or msg filename)",
    ),
    assets: Path = typer.Option("assets", "--assets", "-a", help="Assets folder"),
):
    """
    Convert an Outlook .msg email into a Markdown file with extracted images.
    """
    # Default filename: based on subject, otherwise msg filename
    msg = extract_msg.Message(str(msg_file))
    base_name = sanitize_filename(msg.subject or msg_file.stem)
    md_file = md_file or Path.cwd() / f"{base_name}.md"

    convert_msg_to_md(msg_file, md_file, assets)


if __name__ == "__main__":
    app()
