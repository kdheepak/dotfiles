#!/usr/bin/env bash

command -v tput &> /dev/null && [ -t 1 ] && [ -z "${NO_COLOR:-}" ] || tput() { true; }

# bash strict mode
set -T          # inherit DEBUG and RETURN trap for functions
set -C          # prevent file overwrite by > &> <>
set -E          # inherit -e
set -e          # exit immediately on errors
set -u          # exit on not assigned variables
set -o pipefail # exit on pipe failure

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

################################################################################
# global variables
################################################################################

declare -r PS4='debug($LINENO) ${FUNCNAME[0]:+${FUNCNAME[0]}}(): '
declare -r SCRIPT_VERSION='1.0.0'
declare -r SCRIPT_NAME="./$(basename $0)"
declare -r SCRIPT_PARENT_DIR="$(dirname $0)"
declare -r SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
declare -r PROJECT_DIR=$(realpath $SCRIPT_DIR/..)
declare -r MINIFORGE3_INSTALL_DIRECTORY="$HOME/miniforge3"

# Determine the OS and architecture
case "$(uname)" in
    MINGW* | MSYS*)
        declare -r CONDA_OS="Windows"
        declare -r CONDA_ARCH="x86_64"
        declare -r CONDA_EXT="exe"
        declare -r ON_WINDOWS=true
        ;;
    *)
        declare -r CONDA_OS=$(uname)
        declare -r CONDA_ARCH=$(uname -m)
        declare -r CONDA_EXT="sh"
        declare -r ON_WINDOWS=
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

    run_command curl -fL "$url" -o "$output_file" $CURL_OPTS || error "Unable to download from $url with curl."
}

function download_miniforge3() {

    function help() {
        echo "Usage: $SCRIPT_NAME download-conda [OPTIONS]"
        printf "%-35s %s\n" "  --force" "force download of miniforge3"
        printf "%-35s %s\n" "  --ssl-no-revoke" "disable SSL certificate revocation checks"
        printf "%-35s %s\n" "  --ca-native" "use the system's CA certificates"
        printf "%-35s %s\n" "  --cacert" "use the provided CA certificate file"
        printf "%-35s %s\n" "  --help" "show help menu and options"
    }

    local should_ssl_no_revoke=false
    local should_ca_native=false
    local should_cacert=false
    local should_force_download=false

    while [ ${#} -gt 0 ]; do
        error_message="Error: a value is needed for '$1='"
        case $1 in
            --force)
                should_force_download=true
                shift 1
                ;;
            --ssl-no-revoke)
                should_ssl_no_revoke=true
                shift 1
                ;;
            --ca-native)
                should_ca_native=true
                shift 1
                ;;
            --cacert)
                should_cacert=true
                shift 1
                ;;
            --help)
                help
                safe_exit 0
                ;;
            *)
                help
                error "unknown option '$1'. See help options above."
                break
                ;;
        esac
    done

    # if miniforge3 installer exists and force_download is false, return

    if [[ -f $MINIFORGE3_INSTALLER && $should_force_download == false ]]; then
        info "Miniforge3 installer already found at $MINIFORGE3_INSTALLER ..."
        return
    fi

    info "Downloading miniforge3 installer from $MINIFORGE3_DOWNLOAD_URL to $MINIFORGE3_INSTALLER ..."
    download_with_curl "$MINIFORGE3_DOWNLOAD_URL" "$MINIFORGE3_INSTALLER" "$should_ssl_no_revoke" "$should_ca_native" "$should_cacert"
}

function install_miniforge3() {

    function help() {
        echo "Usage: $SCRIPT_NAME install-config [OPTIONS]"
        printf "%-35s %s\n" "  --force" "force reinstallation of miniforge3"
        printf "%-35s %s\n" "  --help" "show help menu and options"
    }

    local force=false

    while [ ${#} -gt 0 ]; do
        error_message="Error: a value is needed for '$1='"
        case $1 in
            --force)
                force=true
                shift 1
                ;;
            --help)
                help
                safe_exit 0
                ;;
            *)
                help
                error "unknown option '$1'. See help options above."
                break
                ;;
        esac
    done

    if [[ $force == true ]]; then
        info "Forcing reinstallation of miniforge3 ..."
        run_command rm -rf $MINIFORGE3_INSTALL_DIRECTORY
    fi

    # check if miniforge3 already installed
    if [[ -d ${MINIFORGE3_INSTALL_DIRECTORY} ]]; then
        check_python
        return
    fi

    # check if miniforge3_installer exists
    if [[ ! -f $MINIFORGE3_INSTALLER ]]; then
        error "Miniforge3 installer not found at $MINIFORGE3_INSTALLER ..." 'Run `download` subcommand first.'
    else
        info "Miniforge3 installer found at $MINIFORGE3_INSTALLER ..."
    fi

    info "Installing miniforge3 from ${MINIFORGE3_INSTALLER} into ${MINIFORGE3_INSTALL_DIRECTORY} ..."

    if [[ -n $ON_WINDOWS ]]; then
        INSTALL_PREFIX="$(cygpath --windows $MINIFORGE3_INSTALL_DIRECTORY)"
        INSTALLER="$(cygpath --windows $MINIFORGE3_INSTALLER)"
        run_command cmd.exe //C "$INSTALLER /InstallationType=JustMe /RegisterPython=1 /AddToPath=1 /S /D=$INSTALL_PREFIX"
        eval "$(conda shell.bash hook)"
    else
        run_command bash $MINIFORGE3_INSTALLER -b -f -p $MINIFORGE3_INSTALL_DIRECTORY
        source $MINIFORGE3_INSTALL_DIRECTORY/bin/activate
        eval "$(conda shell.bash hook)"
    fi

}

function setup_miniforge3() {

    function help() {
        echo "Usage: $SCRIPT_NAME setup-conda [OPTIONS]"
        printf "%-35s %s\n" "  --init" "add conda initialization to shell startup scripts"
        printf "%-35s %s\n" '  --ssl-verify=$preference' "set conda ssl verify [true|false|truststore]"
        printf "%-35s %s\n" "  --help" "show help menu and options"
    }

    local should_conda_init=false
    local conda_ssl_verify=

    while [ ${#} -gt 0 ]; do
        error_message="Error: a value is needed for '$1='"
        case $1 in
            --init)
                should_conda_init=true
                shift 1
                ;;
            --ssl-verify=*)
                # Extract value after '='
                conda_ssl_verify="${1#*=}"
                shift
                ;;
            --help)
                help
                safe_exit 0
                ;;
            *)
                help
                error "unknown option '$1'. See help options above."
                break
                ;;
        esac
    done

    if [[ $conda_ssl_verify == true ]]; then
        run_command conda config --set ssl_verify $CACERT_PEM_FILE
    elif [[ $conda_ssl_verify == false ]]; then
        run_command conda config --set ssl_verify false
    elif [[ $conda_ssl_verify == "truststore" ]]; then
        run_command conda config --set ssl_verify "truststore"
    elif [[ -n $conda_ssl_verify ]]; then
        run_command conda config --set ssl_verify $conda_ssl_verify
    else
        warn "Not modifying conda config"
    fi

    info "Updating conda ..."
    run_command conda update conda -y

    if [[ $should_conda_init == true ]]; then
        info "Running conda init on all shells ..."
        run_command conda init --all
    else
        warn "Skipping adding conda initialization to shell startup scripts ..."
    fi

    eval "$(conda shell.bash hook)"

    run_command conda install uv -y

    run_command pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pip setuptools --upgrade
    run_command uv pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org pip setuptools --upgrade

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
    cmd="mamba upgrade -y"
    for package in "$@"; do
        cmd+=" $package"
    done
    run_command $cmd
}

download_dependencies() {

    uv_tool_install cookiecutter
    uv_tool_install llm
    uv_tool_install pre-commit
    uv_tool_install pylint
    uv_tool_install httpie
    uv_tool_install black

    mamba_install eza bat delta direnv fzf gh git-lfs ipython jupyter neovim nodejs pandoc ripgrep starship unrar python-localvenv-kernel jupyterlab jupyterlab_execute_time jupyterlab-lsp python-lsp-server jupytext ruff cmake panel hvplot holoviews watchfiles param matplotlib numpy pandas "ibis-framework[duckdb,geospatial]" lonboard just tokei git-cliff

    if [[ -z $ON_WINDOWS ]]; then
        # if ON_WINDOWS is not set
        mamba_install findutils htop jq rsync
    else
        # if ON_WINDOWS is set
        mamba_install 7zip
    fi

    # pip install jupyter_copilot
    pip install jupyterlab-quarto
    pip install jupyterlab-rainbow-brackets
    # pip install jupyterlab_rise
    pip install jupyterlab-code-formatter
    # pip install black isort

    info "Completed!"
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

function main() {
    function help() {
        echo "Usage: $SCRIPT_NAME [COMMAND] [OPTIONS]"
        printf "%-35s %s\n" "  status" "check dependencies"
        printf "%-35s %s\n" "  download" "download miniforge3"
        printf "%-35s %s\n" "  install" "install miniforge3"
        printf "%-35s %s\n" "  setup" "setup miniforge3"
        printf "%-35s %s\n" "  dependencies" "download dependencies"
        printf "%-35s %s\n" "  --version" "show version"
        printf "%-35s %s\n" "  --help" "show help menu and commands"
    }

    if ((${#} == 0)); then
        help
        safe_exit 0
    fi

    case ${1} in
        --help)
            help
            safe_exit 0
            ;;
        --version)
            version
            safe_exit 0
            ;;
        status)
            check_dependencies
            log_python_environment
            ;;
        download)
            download_miniforge3 "${@:2}"
            ;;
        install)
            install_miniforge3 "${@:2}"
            ;;
        setup)
            setup_miniforge3 "${@:2}"
            ;;
        dependencies)
            download_dependencies "${@:2}"
            ;;
        *)
            help
            error "Got unknown command '$1' but expected one of the commands listed above"
            ;;
    esac
}

main "$@"
safe_exit 0
