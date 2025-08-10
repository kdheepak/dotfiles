# Automatic configure script builder
brew "autoconf"
# GNU internationalization (i18n) and localization (l10n) library
brew "gettext"
# Text-based UI library
brew "ncurses"
# Bourne-Again SHell, a UNIX command interpreter
brew "bash"
# GNU binary tools for native development
brew "binutils"
# GNU File, Shell, and Text utilities
brew "coreutils"
# Modern diagram scripting language that turns text to diagrams
brew "d2"
# Secure runtime for JavaScript and TypeScript
brew "deno"
# File comparison utilities
brew "diffutils"
# Pack, ship and run any application as a lightweight container
brew "docker"
# Select default apps for documents and URL schemes on macOS
brew "duti"
# Perl lib for reading and writing EXIF metadata
brew "exiftool"
# Lua Lisp Language
brew "fennel"
# GNU Transport Layer Security (TLS) Library
brew "gnutls"
# Play, record, convert, and stream audio and video
brew "ffmpeg"
# Collection of GNU find, xargs, and locate
brew "findutils"
# User-friendly command-line shell for UNIX-like operating systems
brew "fish"
# Command-line tools for fly.io services
brew "flyctl"
# Formatter for Fennel code
brew "fnlfmt"
# Command-line outline and bitmap font editor/converter
brew "fontforge"
# GNU awk utility
brew "gawk"
# GNU compiler collection
brew "gcc"
# Distributed revision control system
brew "git"
# Git extension for versioning large files
brew "git-lfs"
# C code prettifier
brew "gnu-indent"
# GNU implementation of the famous stream editor
brew "gnu-sed"
# GNU version of the tar archiving utility
brew "gnu-tar"
# GNU implementation of which utility
brew "gnu-which"
# GNU Pretty Good Privacy (PGP) package
brew "gnupg"
# Apply a diff file to an original
brew "gpatch"
# GNU grep, egrep and fgrep
brew "grep"
# Popular GNU data compression program
brew "gzip"
# Pager program similar to more
brew "less"
# Package manager for the Lua programming language
brew "luarocks"
# Utility for directing compilation
brew "make"
# Create, run, and share large language models (LLMs)
brew "ollama"
# OpenBSD freely-licensed SSH connectivity tools
brew "openssh"
# Reattach process (e.g., tmux) to background
brew "reattach-to-user-namespace"
# Terminal multiplexer
brew "tmux"
# Auto-hinter for TrueType fonts
brew "ttfautohint"
# Extraction utility for .zip compressed archives
brew "unzip"
# Compress/expand executable files
brew "upx"
# Executes a program periodically, showing output fullscreen
brew "watch"
# Display word differences between text files
brew "wdiff"
# Internet file retriever
brew "wget"
# Pluggable terminal workspace, with terminal multiplexer as the base feature
brew "zellij"
# Simple hotkey-daemon for macOS.
brew "koekeishiya/formulae/skhd"
# A tiling window manager for macOS based on binary space partitioning.
brew "koekeishiya/formulae/yabai"
# Desktop automation application
cask "hammerspoon"
# 2D game framework for Lua
cask "love"
# Intercept, modify, replay, save HTTP/S traffic
cask "mitmproxy"
# PDF viewer designed for reading research papers and technical books
cask "sioyek"
# GPU-accelerated cross-platform terminal emulator and multiplexer
cask "wezterm@nightly"
# Multiplayer code editor
cask "zed"
# Firefox browser with custom app directory
cask "firefox", args: { appdir: "~/Applications" }

if OS.mac?
    # access to clipboard for images (similar to pbcopy/pbpaste)
    brew "pngpaste"

    # Fonts
    cask "font-fira-code"
    cask "font-jetbrains-mono"
    cask "font-cascadia-mono"
    cask "font-symbols-only-nerd-font"
    cask "font-recursive-code"
    cask "font-monaspace"
elsif OS.linux?
    brew "xclip" # access to clipboard (similar to pbcopy/pbpaste)
end
