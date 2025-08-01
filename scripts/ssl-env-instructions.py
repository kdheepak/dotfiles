#!/usr/bin/env -S uv run
# -*- coding: utf-8 -*-

import os
import platform
import sys
import argparse


def print_current_env_vars(env_keys):
    """Print current environment variable values as a table."""

    # ANSI color codes
    CYAN = "\033[96m"
    BOLD = "\033[1m"
    RESET = "\033[0m"

    print(f"{BOLD}Current Environment Variables:{RESET}")
    print("-" * 80)
    print(f"{BOLD}{'Variable':<30} | {'Current Value'}{RESET}")
    print("-" * 80)

    for key in env_keys:
        value = os.environ.get(key, "")
        print(f"{CYAN}{key:<30}{RESET} | {value}")

    print("-" * 80)
    print()


def print_env_setup(cert_path, show_all=False):
    """Print environment variable setup commands for the target OS."""

    # ANSI color codes
    YELLOW = "\033[93m"
    GREEN = "\033[92m"
    RED = "\033[91m"
    CYAN = "\033[96m"
    BOLD = "\033[1m"
    RESET = "\033[0m"

    if platform.system() == "Windows":
        os.system("")

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

    # Print current env var table
    print_current_env_vars(env_vars.keys())

    def print_section(title, lines):
        print(f"{BOLD}{title}{RESET}:")
        print()
        for line in lines:
            print(line)
        print()

    print(f"{YELLOW}NOTE: Using certificate path: {cert_path}{RESET}\n")

    if show_all or platform.system() == "Windows":
        print_section(
            "Windows Setup (Command Prompt)",
            [
                f"{GREEN}Run the following commands in Command Prompt:{RESET}",
                *[f"setx {var} {val}" for var, val in env_vars.items()],
            ],
        )

    if show_all or platform.system() in ["Linux", "Darwin"]:
        print_section(
            "macOS/Linux Setup (bash/zsh)",
            [
                f"{GREEN}Add the following lines to your shell config file "
                f"(`~/.bashrc`, `~/.zshrc`, etc.):{RESET}\n",
                *[f"export {var}={val}" for var, val in env_vars.items()],
                f"\n{CYAN}Then restart your terminal to apply changes.{RESET}",
            ],
        )

    if not show_all and platform.system() not in ["Windows", "Linux", "Darwin"]:
        print(
            f"{RED}Unsupported operating system: {platform.system()}{RESET}",
            file=sys.stderr,
        )
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
    parser.add_argument(
        "-a",
        "--all",
        action="store_true",
        help="Show setup instructions for all supported operating systems",
    )

    args = parser.parse_args()
    print_env_setup(args.cert_path, show_all=args.all)
