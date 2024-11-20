#!/usr/bin/env bash

command -v tput &> /dev/null && [ -t 1 ] && [ -z "${NO_COLOR:-}" ] || tput() { true; }

set -euo pipefail

BG_BLACK=$(tput setab 0)
BG_RED=$(tput setab 1)
BG_GREEN=$(tput setab 2)
BG_YELLOW=$(tput setab 3)
BG_BLUE=$(tput setab 4)
BG_MAGENTA=$(tput setab 5)
BG_CYAN=$(tput setab 6)
BG_WHITE=$(tput setab 7)
BG_DEFAULT=$(tput setab 9)

BG_BRIGHT_BLACK=$(tput setab 8)    # Not widely supported
BG_BRIGHT_RED=$(tput setab 9)      # Not widely supported
BG_BRIGHT_GREEN=$(tput setab 10)   # Not widely supported
BG_BRIGHT_YELLOW=$(tput setab 11)  # Not widely supported
BG_BRIGHT_BLUE=$(tput setab 12)    # Not widely supported
BG_BRIGHT_MAGENTA=$(tput setab 13) # Not widely supported
BG_BRIGHT_CYAN=$(tput setab 14)    # Not widely supported
BG_BRIGHT_WHITE=$(tput setab 15)   # Not widely supported
BG_BRIGHT_DEFAULT=$(tput setab 9)

FG_BLACK=$(tput setaf 0)
FG_RED=$(tput setaf 1)
FG_GREEN=$(tput setaf 2)
FG_YELLOW=$(tput setaf 3)
FG_BLUE=$(tput setaf 4)
FG_MAGENTA=$(tput setaf 5)
FG_CYAN=$(tput setaf 6)
FG_WHITE=$(tput setaf 7)
FG_DEFAULT=$(tput setaf 9)

FG_BRIGHT_BLACK=$(tput setaf 8)    # Not widely supported
FG_BRIGHT_RED=$(tput setaf 9)      # Not widely supported
FG_BRIGHT_GREEN=$(tput setaf 10)   # Not widely supported
FG_BRIGHT_YELLOW=$(tput setaf 11)  # Not widely supported
FG_BRIGHT_BLUE=$(tput setaf 12)    # Not widely supported
FG_BRIGHT_MAGENTA=$(tput setaf 13) # Not widely supported
FG_BRIGHT_CYAN=$(tput setaf 14)    # Not widely supported
FG_BRIGHT_WHITE=$(tput setaf 15)   # Not widely supported
FG_BRIGHT_DEFAULT=$(tput setaf 9)

BOLD=$(tput bold)
RESET=$(tput sgr0)
BLINK=$(tput blink)

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
MINIFORGE3_INSTALL_DIRECTORY="$HOME/miniforge3"

CACERT_PEM_FILE=$SCRIPT_DIR/cacert.pem

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
tip() {
    echo -e "${FG_BRIGHT_BLACK}${BG_CYAN}${BOLD} TIP ${RESET}: ${FG_CYAN}$1${RESET}"
}

error() {
    echo -e "
${FG_BRIGHT_BLACK}${BG_RED}${BOLD} ERROR ${RESET}: ${FG_RED}$1${RESET}"

    if [[ -n ${2:-} ]]; then
        tip $2
    fi

    echo -e "
If you have any questions, contact the developers for support."

    safe_exit 1
}

warn() {
    echo -e "
${FG_BRIGHT_BLACK}${BG_YELLOW}${BOLD}${BLINK} WARN ${RESET}: ${FG_YELLOW}$1${RESET}"
}

log() {
    echo -e "
${FG_BRIGHT_BLACK}${BG_GREEN}${BOLD} LOG ${RESET}: ${FG_GREEN}$1${RESET}"
}

info() {
    echo -e "
${FG_WHITE}${BG_BLUE}${BOLD} INFO ${RESET}: ${FG_BLUE}$1${RESET}"
}

execute() {
    echo -e "
${FG_WHITE}${BG_MAGENTA}${BOLD} EXECUTE ${RESET}: ${FG_MAGENTA}$1${RESET}"
}

run_command() {
    execute "+ $*"
    "$@"
}

check_dependencies() {

    info "Checking dependencies for install script ..."

    # Check for required dependencies

    # If curl is not installed exit.
    command -v curl > /dev/null 2>&1 || error "curl is required but not installed." "Please install curl and try again."

    # If conda is already installed and it is miniforge continue.
    # If conda is already installed but is not miniforge, install miniforge
    # If conda is not installed but python is installed, install miniforge
    # If conda is not installed and python is not installed, install miniforge
    if command -v conda > /dev/null 2>&1; then
        EXISTING_CONDA_INSTALLATION=$(which conda)
        if [[ $EXISTING_CONDA_INSTALLATION == *miniforge* ]]; then
            info "Conda (Miniforge) is already installed. Continuing ..."
        else
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
}

# Function to download files with curl options
download_with_curl() {
    local url=$1
    local output_file=$2
    local ssl_no_revoke=$3
    local ca_native=$4
    local cacert=$5

    # Reset positional parameters so that subcommands don't see the script arguments
    shift $#

    CURL_OPTS=""

    if [[ $ssl_no_revoke == true ]]; then
        CURL_OPTS="$CURL_OPTS --ssl-no-revoke"
    fi
    if [[ $ca_native == true ]]; then
        CURL_OPTS="$CURL_OPTS --ca-native"
    fi
    if [[ $cacert == true ]]; then
        CURL_OPTS="$CURL_OPTS --cacert $CACERT_PEM_FILE"
    fi

    run_command curl -fL "$url" -o "$output_file" $CURL_OPTS || error "Unable to download from $url with curl."
}

# Function to install miniforge3
install_miniforge3() {

    local should_remove_miniforge3=${1:-false}
    local should_mamba_init=${2:-false}
    local should_ssl_no_revoke=${3:-false}
    local should_ca_native=${4:-false}
    local should_cacert=${5:-false}
    local should_conda_ssl_verify=${6:-}

    # Reset positional parameters so that subcommands don't see the script arguments
    shift $#

    if [[ $should_remove_miniforge3 == true ]]; then
        info "Removing miniforge3 ..."
        run_command rm -rf ~/miniforge3/
    fi

    if [[ ! -d $MINIFORGE3_INSTALL_DIRECTORY ]]; then
        info "Downloading miniforge3 ..."

        download_with_curl "$MINIFORGE3_DOWNLOAD_URL" "$MINIFORGE3_INSTALLER" "$should_ssl_no_revoke" "$should_ca_native" "$should_cacert"

        info "Installing miniforge3 ..."

        if [[ -n $ON_WINDOWS ]]; then
            INSTALL_PREFIX="$(cygpath --windows $MINIFORGE3_INSTALL_DIRECTORY)"
            INSTALLER="$(cygpath --windows $MINIFORGE3_INSTALLER)"
            run_command cmd.exe //C "$INSTALLER /InstallationType=JustMe /RegisterPython=1 /AddToPath=1 /S /D=$INSTALL_PREFIX"
            source $MINIFORGE3_INSTALL_DIRECTORY/Scripts/activate
        else
            run_command bash $MINIFORGE3_INSTALLER -b -f -p $MINIFORGE3_INSTALL_DIRECTORY
            source $MINIFORGE3_INSTALL_DIRECTORY/bin/activate
        fi

        info "Installing Python 3.12 ..."

        if [[ $should_conda_ssl_verify == true ]]; then
            run_command conda config --set ssl_verify $CACERT_PEM_FILE
        elif [[ $should_conda_ssl_verify == false ]]; then
            run_command conda config --set ssl_verify false
        else
            info "No modifying conda config"
        fi

        run_command mamba update mamba -y
        run_command mamba install python=3.12 -y

        if [[ $should_mamba_init == true ]]; then
            info "Running conda init on all shells ..."
            run_command mamba init --all
        fi

        run_command pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pip setuptools --upgrade
        run_command uv pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pip setuptools --upgrade

    else
        log "miniforge3 is already installed at $RESET'$MINIFORGE3_INSTALL_DIRECTORY'"
    fi
}

check_python() {
    if ! command -v python &> /dev/null; then
        error "miniforge3 installation found at '$MINIFORGE3_INSTALL_DIRECTORY' however 'python' not found in PATH." "Consider the following options in order:

1. Restart your terminal application and try running this script again.
2. Restart your computer and try running this script again.
3. Delete '$MINIFORGE3_INSTALL_DIRECTORY' and try running this script again."
    else

        PYTHON_PATH=$(python -c "import sys; print(sys.executable)")
        log "python is already installed at $RESET'$PYTHON_PATH'"

        python -c "
import sys
import pathlib
import os
exe = pathlib.Path(sys.executable)
home = pathlib.Path(os.getenv('HOME'))
if not home in exe.parents:
    print(f'${FG_WHITE}${BG_RED}${BOLD} ERROR ${RESET}: Found \'{sys.executable}\' but expected python from miniforge installation. You may have multiple pythons installed. Contact the developers for support.')
    sys.exit(-1)
        "
    fi
}

uv_tool_install() {
    local tool_name="$1"
    info "Installing $tool_name with uv ..."
    run_command uv tool install "$tool_name" --force
}

mamba_install() {
    info "Installing $@ with mamba ..."
    # Construct the install command
    cmd="mamba install -y"
    for package in "$@"; do
        cmd+=" $package"
    done
    run_command $cmd
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

}

main() {
    local should_remove_miniforge3=false
    local should_mamba_init=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --force-reinstall)
                should_remove_miniforge3=true
                ;;
            --enable-mamba-init)
                should_mamba_init=true
                ;;
            *)
                error "Unknown option: $1"
                ;;
        esac
        shift
    done

    check_dependencies

    install_miniforge3 $should_remove_miniforge3 $should_mamba_init

    check_python

    log_python_environment

    uv_tool_install cookiecutter
    uv_tool_install llm
    uv_tool_install pre-commit
    uv_tool_install pylint
    uv_tool_install httpie
    mamba_install eza bat delta direnv fzf gh git-lfs ipython jupyter neovim nodejs pandoc ripgrep starship unrar python-localvenv-kernel jupyterlab_execute_time jupyterlab-lsp python-lsp-server jupytext ruff cmake panel watchfiles param matplotlib numpy pandas "ibis-framework[duckdb]"

    if [[ -z $ON_WINDOWS ]]; then
        # if ON_WINDOWS is not set
        mamba_install findutils htop jq rsync
    else
        # if ON_WINDOWS is set
        mamba_install 7zip
    fi

    pip install jupyter_copilot
    pip install jupyterlab-quarto
    pip install jupyterlab-rainbow-brackets
    pip install jupyterlab_rise
    pip install jupyterlab-code-formatter
    pip install black isort

    info "Completed!"
}

main "$@"
