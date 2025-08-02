#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "pyperclip",
# ]
# ///

import pyperclip
import getpass


def anonymize_username(content, username):
    return content.replace(username, "XXXXXX")


def main():
    username = getpass.getuser()
    content = pyperclip.paste()

    anonymized_content = anonymize_username(content, username)
    print(anonymized_content)


if __name__ == "__main__":
    main()
