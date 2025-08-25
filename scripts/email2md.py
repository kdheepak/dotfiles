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


def clean_text(text: str) -> str:
    """Thoroughly clean text of null bytes and non-printable characters."""
    if not text:
        return ""

    # Remove null bytes first
    text = text.replace("\x00", "")

    # Remove other problematic control characters but keep newlines, tabs, carriage returns
    cleaned_chars = []
    for char in text:
        # Keep printable characters and essential whitespace
        if char.isprintable() or char in "\n\r\t":
            cleaned_chars.append(char)
        # Replace other control characters with space
        elif ord(char) < 32:
            cleaned_chars.append(" ")

    return "".join(cleaned_chars)


def sanitize_filename(name: str) -> str:
    """Remove invalid characters for filenames."""
    if not name:
        return "untitled"
    return re.sub(r"[^a-zA-Z0-9_.-]", "_", name).strip("_") or "untitled"


def safe_decode_html(html_content) -> str:
    """Safely decode HTML content to string."""
    if isinstance(html_content, bytes):
        # Try multiple encodings
        for encoding in ["utf-8", "utf-16", "latin-1", "cp1252"]:
            try:
                decoded = html_content.decode(encoding, errors="ignore")
                # Clean immediately after decoding
                return clean_text(decoded)
            except (UnicodeDecodeError, LookupError):
                continue
        # Fallback: force decode with replacement
        return clean_text(html_content.decode("utf-8", errors="replace"))

    return clean_text(str(html_content))


def convert_msg_to_md(
    msg_path: Path,
    output_md: Path,
    assets_folder: Path = Path("assets"),
):
    # Load message
    msg = extract_msg.Message(str(msg_path))
    subject = clean_text(msg.subject or "No Subject")
    sender = clean_text(msg.sender or "Unknown Sender")
    date = clean_text(str(msg.date) if msg.date else "")

    # Get the best available body content
    body = ""
    if msg.htmlBody:
        # HTML body takes precedence, decode it safely
        body = safe_decode_html(msg.htmlBody)
    elif msg.body:
        # Fallback to plain text body
        body = clean_text(msg.body)

    # Ensure assets folder exists
    assets_folder.mkdir(parents=True, exist_ok=True)

    # Extract attachments
    attachment_links = {}
    for att in track(msg.attachments, description="Extracting attachments..."):
        filename = sanitize_filename(att.longFilename or att.shortFilename)
        if not filename:
            continue

        filepath = assets_folder / filename
        try:
            with open(filepath, "wb") as f:
                f.write(att.data)
            attachment_links[filename] = filepath
        except Exception as e:
            console.print(
                f"[yellow]Warning: Could not save attachment {filename}: {e}[/yellow]"
            )

    # Replace inline images in HTML body (if HTML)
    if body and "<html" in body.lower():
        for cid, filepath in attachment_links.items():
            short_name = filepath.name
            # More robust CID replacement
            patterns = [
                rf"cid:{re.escape(cid)}",
                rf"cid:{re.escape(cid.replace(' ', '%20'))}",  # URL encoded spaces
                rf"src=[\"']cid:{re.escape(cid)}[\"']",
            ]

            for pattern in patterns:
                body = re.sub(
                    pattern,
                    f"./{assets_folder.name}/{short_name}",
                    body,
                    flags=re.IGNORECASE,
                )

    # Convert HTML to Markdown if it's HTML content
    if body and (
        "<html" in body.lower() or "<div" in body.lower() or "<p" in body.lower()
    ):
        h = html2text.HTML2Text()
        h.ignore_links = False
        h.ignore_images = False
        h.ignore_emphasis = False
        h.body_width = 0  # Don't wrap lines

        try:
            body = h.handle(body)
        except Exception as e:
            console.print(f"[yellow]Warning: HTML conversion failed: {e}[/yellow]")
            # Fallback: strip HTML tags manually
            body = re.sub(r"<[^>]+>", "", body)

    # Final comprehensive cleanup
    body = clean_text(body)

    # Remove excessive whitespace but preserve paragraph breaks
    body = re.sub(r"\n\s*\n\s*\n+", "\n\n", body)  # Multiple newlines to double
    body = re.sub(r"[ \t]+", " ", body)  # Multiple spaces/tabs to single space
    body = body.strip()

    # Check if file exists and ask before overwriting
    if output_md.exists():
        overwrite = typer.confirm(
            f"File '{output_md.name}' already exists. Overwrite?", default=False
        )
        if not overwrite:
            console.print("[yellow]Aborted by user.[/yellow]")
            raise typer.Exit()

    # Write markdown file with explicit encoding and error handling
    try:
        with open(output_md, "w", encoding="utf-8", errors="replace") as f:
            f.write(f"# {subject}\n\n")
            f.write(f"**From:** {sender}  \n")
            f.write(f"**Date:** {date}\n\n")
            if attachment_links:
                f.write("## Attachments\n\n")
                for filename, filepath in attachment_links.items():
                    f.write(f"- [{filename}](./{assets_folder.name}/{filename})\n")
                f.write("\n")
            f.write("## Content\n\n")
            f.write(body)
            f.write("\n")
    except Exception as e:
        console.print(f"[red]Error writing file: {e}[/red]")
        raise typer.Exit(1)

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
    if not msg_file.exists():
        console.print(f"[red]Error: File {msg_file} does not exist.[/red]")
        raise typer.Exit(1)

    # Default filename: based on subject, otherwise msg filename
    try:
        msg = extract_msg.Message(str(msg_file))
        base_name = sanitize_filename(msg.subject or msg_file.stem)
    except Exception as e:
        console.print(f"[red]Error reading MSG file: {e}[/red]")
        raise typer.Exit(1)

    md_file = md_file or Path.cwd() / f"{base_name}.md"

    try:
        convert_msg_to_md(msg_file, md_file, assets)
    except Exception as e:
        console.print(f"[red]Conversion failed: {e}[/red]")
        raise typer.Exit(1)


if __name__ == "__main__":
    app()
