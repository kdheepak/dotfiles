#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pyperclip",
# ]
# ///

import sys
import pyperclip
import getpass


def anonymize_username(content, username):
    return content.replace(username, "USERNAME_PLACEHOLDER")


def main():
    username = getpass.getuser()
    if not sys.stdin.isatty():
        content = sys.stdin.read()
    else:
        content = pyperclip.paste()

    anonymized_content = anonymize_username(content, username)
    print(anonymized_content)
