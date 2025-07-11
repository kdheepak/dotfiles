#!/usr/bin/env -S uv run --script
# -*- coding: utf-8 -*-
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "rich",
#     "typer",
# ]
# ///
"""
Runs a command with a timeout and redacts sensitive paths/usernames from output.
Usage:
./run-with-timeout.py 10 -- <your command>
"""

import subprocess
import os
import re
import time
import threading
import signal
from typing import List, Optional

import typer
from rich.console import Console
from rich.progress import (
    Progress,
    SpinnerColumn,
    TextColumn,
    BarColumn,
    TimeElapsedColumn,
)

console = Console()
app = typer.Typer(
    help="Run commands with timeout and output redaction",
    add_completion=False,
    no_args_is_help=True,
)


def sanitize(text: str) -> str:
    """Redact likely sensitive values from text output."""
    username = (
        os.getenv("USER")
        or os.getenv("USERNAME")
        or os.path.basename(os.path.expanduser("~"))
    )
    patterns = [
        username,
        os.path.expanduser("~"),
        re.escape(os.path.expanduser("~")),
        r"/Users/[^/]+",  # Mac home directory path
        r"/home/[^/]+",  # Linux home directory path
        r"C:\\Users\\[^\\]+",  # Windows home directory path
    ]
    for pattern in patterns:
        text = re.sub(pattern, "[REDACTED]", text, flags=re.IGNORECASE)
    return text


class TimeoutError(Exception):
    """Raised when command times out."""

    pass


def run_and_capture(command: list[str], timeout_seconds: Optional[float] = None):
    """Run a command with optional timeout, streaming output in real-time."""
    process = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        bufsize=1,
        universal_newlines=True,
        preexec_fn=os.setsid
        if os.name != "nt"
        else None,  # For process group termination
    )

    output = ""
    output_lines = []

    def read_output():
        """Read output in a separate thread."""
        nonlocal output
        try:
            for line in process.stdout:
                # Sanitize sensitive info but preserve ANSI color codes
                sanitized_line = sanitize(line.rstrip())
                # Use Rich's capability to properly render ANSI codes
                console.print(sanitized_line, highlight=False, markup=False)
                output += line
                output_lines.append(line)
        except ValueError:
            # Stream closed
            pass

    # Start reading thread
    reader_thread = threading.Thread(target=read_output, daemon=True)
    reader_thread.start()

    try:
        with Progress(
            SpinnerColumn(),
            TextColumn("[progress.description]{task.description}"),
            BarColumn(),
            TimeElapsedColumn(),
            console=console,
            transient=True,
        ) as progress:
            task_desc = f"Running: [code]`{' '.join(command)}`[/code]"
            if timeout_seconds:
                task_desc += f" (timeout: {timeout_seconds}s)"

            task = progress.add_task(task_desc, total=timeout_seconds or 1)

            start_time = time.time()

            # Poll process while updating progress
            while process.poll() is None:
                elapsed = time.time() - start_time

                if timeout_seconds:
                    progress.update(task, completed=elapsed)
                    if elapsed >= timeout_seconds:
                        raise subprocess.TimeoutExpired(command, timeout_seconds)
                else:
                    # For no timeout, just update to show elapsed time
                    progress.update(task, completed=elapsed)

                time.sleep(0.1)  # Small sleep to avoid busy waiting

            # Final update
            elapsed = time.time() - start_time
            progress.update(task, completed=elapsed)

        return_code = process.returncode

        # Wait for reader thread to finish
        reader_thread.join(timeout=1.0)

        if return_code != 0:
            raise RuntimeError(f"Command failed with exit code {return_code}")

        return sanitize(output)

    except subprocess.TimeoutExpired:
        console.print(
            f"\n[bold red]Command timed out after {timeout_seconds} seconds[/]"
        )

        # Terminate the process group
        try:
            if os.name != "nt":
                os.killpg(os.getpgid(process.pid), signal.SIGTERM)
            else:
                process.terminate()

            # Give it a moment to terminate gracefully
            try:
                process.wait(timeout=2.0)
            except subprocess.TimeoutExpired:
                # Force kill if it doesn't terminate
                if os.name != "nt":
                    os.killpg(os.getpgid(process.pid), signal.SIGKILL)
                else:
                    process.kill()
                process.wait()
        except (ProcessLookupError, OSError):
            # Process already terminated
            pass

        raise TimeoutError(f"Command timed out after {timeout_seconds} seconds")

    finally:
        # Ensure stdout is closed
        if process.stdout and not process.stdout.closed:
            process.stdout.close()


@app.command()
def main(
    timeout: float = typer.Argument(..., help="Timeout in seconds"),
    command: List[str] = typer.Argument(..., help="Command to run (after --)"),
):
    """
    Run a command with a timeout and redact sensitive information from output.

    Example:
        ./run-with-timeout.py 10 -- ls -la
        ./run-with-timeout.py 30 -- python my_script.py
    """
    if not command:
        console.print("[bold red]Error:[/] No command provided")
        raise typer.Exit(1)

    try:
        run_and_capture(command, timeout)

        console.print("")
        console.print("[bold green]Command completed successfully![/]")

    except TimeoutError as e:
        console.print(f"\n[bold red]Error:[/] {e}")
        raise typer.Exit(124)  # Timeout exit code

    except RuntimeError as e:
        console.print(f"\n[bold red]Error:[/] {e}")
        raise typer.Exit(1)

    except KeyboardInterrupt:
        console.print("\n[bold yellow]Interrupted by user[/]")
        raise typer.Exit(130)

    except Exception as e:
        console.print(f"\n[bold red]Unexpected error:[/] {e}")
        raise typer.Exit(1)


if __name__ == "__main__":
    app()
