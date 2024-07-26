#!/usr/bin/env bash

set -euo pipefail

# Color codes
WHITE='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
ON_RED='\033[41m'
ON_GREEN='\033[42m'
ON_YELLOW='\033[43m'
ON_BLUE='\033[44m'
ON_PURPLE='\033[45m'
BOLD='\033[1m'
RESET='\033[0m'
BLINK='\033[5m'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
MINIFORGE3_INSTALL_DIRECTORY="$HOME/miniforge3"
FORCE_INSTALL=false

# Determine the OS and architecture
case "$(uname)" in
    MINGW* | MSYS*)
        CONDA_OS="Windows"
        CONDA_ARCH="x86_64"
        CONDA_EXT="exe"
        ON_WINDOWS=true
        ;;
    *)
        CONDA_OS=$(uname)
        CONDA_ARCH=$(uname -m)
        CONDA_EXT="sh"
        ON_WINDOWS=
        ;;
esac

MINIFORGE3_DOWNLOAD_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-${CONDA_OS}-${CONDA_ARCH}.${CONDA_EXT}"
MINIFORGE3_INSTALLER="$HOME/Downloads/Miniforge3-${CONDA_OS}-${CONDA_ARCH}.${CONDA_EXT}"

safe_exit() {
    if [[ -n $ON_WINDOWS ]]; then
        echo -e "Press any key to exit ..."
        read -n 1 -s
        exit $1
    else
        exit $1
    fi
}

# Functions for printing messages
error() {
    echo -e "${WHITE}${ON_RED}${BOLD}${BLINK} ERROR ${RESET}: ${RED}$1${RESET}"

    if [[ -n ${2:-} ]]; then
        echo -e "
${WHITE}${ON_PURPLE}${BOLD}${BLINK} TIP ${RESET}: ${PURPLE}$2${RESET}"
    fi

    echo -e "
Something has gone wrong with your installation. If you have any questions, contact the developers for support."

    safe_exit 1
}

warn() {
    echo -e "${WHITE}${ON_YELLOW}${BOLD}${BLINK} WARN ${RESET}: ${YELLOW}$1${RESET}"
}

log() {
    echo -e "${WHITE}${ON_GREEN}${BOLD}${BLINK} LOG ${RESET}: ${GREEN}$1${RESET}"
}

info() {
    echo -e "${WHITE}${ON_BLUE}${BOLD}${BLINK} INFO ${RESET}: ${BLUE}$1${RESET}"
}

check_dependencies() {

    # Check for required dependencies

    # If curl is not installed exit.
    command -v curl > /dev/null 2>&1 || error "curl is required but not installed." "Please install curl and try again."

    # If conda is already installed and it is miniforge continue.
    # If conda is already installed but is not miniforge, install miniforge
    # If conda is not installed but python is installed, install miniforge
    # If conda is not installed and python is not installed, install miniforge
    if command -v conda > /dev/null 2>&1; then
        EXISTING_CONDA_INSTALLATION=$(which conda)
        # Check if conda is from Miniforge
        if [[ $EXISTING_CONDA_INSTALLATION != *miniforge* ]]; then
            log "conda  : $RESET'$(which conda)'"
            warn "Conda is installed but is not Miniforge3. If you proceed, Miniforge3 will be installed as part of this script. We recommend deleting your previous installation of Python."
            read -p "Proceed anyway? (y/n): " choice
            case "$choice" in
                y | Y) info "Proceeding with installing miniforge3 ..." ;;
                n | N)
                    info "Installation aborted."
                    safe_exit 0
                    ;;
                *)
                    error "Invalid choice. Installation aborted."
                    safe_exit 1
                    ;;
            esac
        fi
    else
        if command -v python > /dev/null 2>&1; then
            info "Existing installation detected ..."

            log "python  : $RESET'$(which python)'"
            warn "Python is installed but conda is not. If you proceed, Miniforge3 will be installed as part of this script. Your existing install will be unaffected."
            read -p "Proceed anyway? (y/n): " choice
            case "$choice" in
                y | Y) info "Proceeding with installing miniforge3 ..." ;;
                n | N)
                    info "Installation aborted."
                    safe_exit 0
                    ;;
                *)
                    error "Invalid choice. Installation aborted."
                    safe_exit 1
                    ;;
            esac
        else
            info "conda and python are not installed. It will be installed as part of this script. Continuing ..."
        fi
    fi
    command -v mamba > /dev/null 2>&1 || info "mamba is not installed. It will be installed as part of this script."
    command -v pipx > /dev/null 2>&1 || info "pipx is not installed. It will be installed as part of this script."
}

install_miniforge3() {
    if [[ ! -d $MINIFORGE3_INSTALL_DIRECTORY ]]; then
        info "Downloading miniforge3 ..."
        curl -fsSL $MINIFORGE3_DOWNLOAD_URL -o $MINIFORGE3_INSTALLER

        info "Installing miniforge3 ..."

        if [[ -n $ON_WINDOWS ]]; then
            INSTALL_PREFIX="$(cygpath --windows $MINIFORGE3_INSTALL_DIRECTORY)"
            INSTALLER="$(cygpath --windows $MINIFORGE3_INSTALLER)"
            cmd.exe //C "$INSTALLER /InstallationType=JustMe /RegisterPython=1 /AddToPath=1 /S /D=$INSTALL_PREFIX"
            source $MINIFORGE3_INSTALL_DIRECTORY/Scripts/activate
        else
            bash $MINIFORGE3_INSTALLER -b -f -p $MINIFORGE3_INSTALL_DIRECTORY
            source $MINIFORGE3_INSTALL_DIRECTORY/bin/activate
        fi

        conda config --set ssl_verify False
        mamba update mamba -y
        mamba install -y -n base -c conda-forge conda-libmamba-solver
        conda config --set solver libmamba

        info "Installing Python 3.12 ..."

        mamba install python=3.12 -y

        info "Activating conda shell $(basename $SHELL) ..."

        mamba init $(basename $SHELL)

        python -m pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pip setuptools --upgrade

        info "Restart your terminal application and re-run this script to proceed."
        safe_exit 0
    fi
}

check_python() {
    if ! command -v python &> /dev/null; then
        error "miniforge3 installation found at '$MINIFORGE3_INSTALL_DIRECTORY' however 'python' not found in PATH." "Consider the following checklist:

1. Restart your terminal application and try running this script again.
2. Restart your computer and try running this script again.
3. Delete '$MINIFORGE3_INSTALL_DIRECTORY' and try running this script again."
    else

        PYTHON_PATH=$(python -c "import sys; print(sys.executable)")

        python -c "
import sys
import pathlib
import os
exe = pathlib.Path(sys.executable)
home = pathlib.Path(os.getenv('HOME'))
if not home in exe.parents:
    print(f'${WHITE}${ON_RED}${BOLD}${BLINK} ERROR ${RESET}: Found \'{sys.executable}\' but expected python from miniforge installation. You may have multiple pythons installed. Contact the developers for support to proceed.')
    sys.exit(-1)
        "
    fi
}

_delete_dir_contents() {
    local dir_path="$1"
    if [[ -d $dir_path ]]; then
        rm -rf "$dir_path"/*
        info "Deleted: $dir_path"
    else
        info "Dir not found: $dir_path"
    fi
}

install_pipx() {
    if ! python -m pipx --version &> /dev/null; then
        info "Installing pipx ..."
        python -m pip install pipx
        python -m pipx ensurepath

        PIPX_VENV_CACHEDIR=$(python -m pipx environment | grep "PIPX_VENV_CACHEDIR=" | cut -d '=' -f 2 | xargs)
        PIPX_LOCAL_VENVS=$(python -m pipx environment | grep "PIPX_LOCAL_VENVS=" | cut -d '=' -f 2 | xargs)

        if [[ -n $ON_WINDOWS ]]; then
            PIPX_VENV_CACHEDIR=$(cygpath.exe --unix "$PIPX_VENV_CACHEDIR")
            PIPX_LOCAL_VENVS=$(cygpath.exe --unix "$PIPX_LOCAL_VENVS")
            PIPX_BIN_DIR=$(cygpath.exe --unix "$PIPX_BIN_DIR")
        fi

        _delete_dir_contents "$PIPX_VENV_CACHEDIR"
        _delete_dir_contents "$PIPX_LOCAL_VENVS"

        info "Restart your terminal application and re-run this script to proceed."
        safe_exit 0
    fi
}

pipx_install() {
    local tool_name="$1"
    if command -v "$tool_name" > /dev/null 2>&1; then
        if $FORCE_INSTALL; then
            info "Installing $tool_name ..."
            python -m pipx uninstall "$tool_name"
            python -m pipx install "$tool_name" --force
        else
            info "$tool_name is already installed."
        fi
    else
        info "Installing $tool_name ..."
        python -m pipx install "$tool_name" --force
    fi
}

mamba_install() {
    local tool_name="$1"
    info "Installing $tool_name with mamba ..."
    mamba install -y -q -c conda-forge "$tool_name"
}

log_python_environment() {
    log "python  : $RESET$(python -c "import sys; print(sys.executable)")"
    log "python3 : $RESET$(python3 -c "import sys; print(sys.executable)")"

    echo ""

    local space="                       "
    log "which python  : $RESET$(which -a python | awk -v space="$space" 'NR==1{print; next} {print space $0}')"
    log "which conda   : $RESET$(which -a conda | awk -v space="$space" 'NR==1{print; next} {print space $0}')"
    log "which mamba   : $RESET$(which -a mamba | awk -v space="$space" 'NR==1{print; next} {print space $0}')"
    log "which pip     : $RESET$(which -a pip | awk -v space="$space" 'NR==1{print; next} {print space $0}')"
    log "which pipx    : $RESET$(which -a pipx | awk -v space="$space" 'NR==1{print; next} {print space $0}')"

}

show_help() {
    echo "Usage: $(basename $0) [OPTIONS]"
    echo "Install Miniforge, Python, pipx, and poetry."
    echo ""
    echo "Options:"
    echo "  --help         Show this help message and exit"
    echo "  --skip-poetry  Skip the poetry installation"
    echo "  --skip-pipx    Skip the pipx installation"
    echo "  --force        Force reinstall"
}

main() {

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help)
                show_help
                safe_exit 0
                ;;
            --force)
                FORCE_INSTALL=true
                ;;
            *)
                show_help
                error "Unknown option: $1"
                ;;
        esac
        shift
    done

    check_dependencies
    install_miniforge3
    check_python
    install_pipx
    log_python_environment
    pipx_install poetry
    pipx_install pre-commit
    pipx_install black
    pipx_install pylint
    mamba_install bat
    mamba_install delta
    mamba_install direnv
    mamba_install exa
    mamba_install findutils
    mamba_install fzf
    mamba_install gh
    mamba_install git-lfs
    mamba_install htop
    mamba_install httpie
    mamba_install jq
    mamba_install nodejs
    mamba_install neovim
    mamba_install pandoc
    mamba_install ripgrep
    mamba_install rsync
    mamba_install starship
    mamba_install unrar
    mamba_install unzip
    mamba_install ipython
    mamba_install jupyter
    git lfs install
}

main "$@"
