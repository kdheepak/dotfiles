#!/usr/bin/env -S uv run
# -*- coding: utf-8 -*-

import os
import platform
import sys
import argparse


def print_env_setup(cert_path):
    """Print environment variable setup commands for the current OS."""

    # ANSI color codes
    YELLOW = "\033[93m"
    GREEN = "\033[92m"
    RED = "\033[91m"
    CYAN = "\033[96m"
    BOLD = "\033[1m"
    RESET = "\033[0m"

    # Enable ANSI escape codes on Windows (no-op if unsupported)
    if platform.system() == "Windows":
        os.system("")

    # Expand ~ in path
    cert_path = os.path.expanduser(cert_path)
    cert_dir = os.path.dirname(cert_path)

    env_vars = {
        "CURL_CA_BUNDLE": cert_path,
        "REQUESTS_CA_BUNDLE": cert_path,
        "SSL_CERT_FILE": cert_path,
        "SSL_CERT_DIR": cert_dir,
        "PYTHONHTTPSVERIFY": 1,
        "SSL_VERIFY": "true",
    }

    system = platform.system()

    def print_section(title, lines):
        print(f"{BOLD}{title}{RESET}:")
        print("")
        for line in lines:
            print(line)
        print()

    if system == "Windows":
        print_section(
            "Windows Setup (Command Prompt)",
            [
                f"{GREEN}Run the following commands in Command Prompt:{RESET}",
                *[f'setx {var} "{val}"' for var, val in env_vars.items()],
            ],
        )

    elif system in ["Linux", "Darwin"]:
        print_section(
            "macOS/Linux Setup (bash/zsh)",
            [
                f"{CYAN}Add the following lines to your shell config file "
                f"(`~/.bashrc`, `~/.zshrc`, etc.):{RESET}\n",
                *[f"export {var}={val}" for var, val in env_vars.items()],
                f"\n{CYAN}Then restart your terminal.",
            ],
        )
    else:
        print(f"{RED}❌ Unsupported operating system: {system}{RESET}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Generate environment variable setup commands for SSL certificates."
    )
    parser.add_argument(
        "cert_path",
        nargs="?",
        default="~/.config/certs/cacert.pem",
        help="Path to the certificate file (default: ~/.config/certs/cacert.pem)",
    )
    args = parser.parse_args()
    print_env_setup(args.cert_path)
