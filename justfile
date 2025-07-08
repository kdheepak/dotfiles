#!/usr/bin/env -S just --justfile
# Global justfile with common system utilities

set shell := ["bash", "-uc"]
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Show all available commands
_default:
    @just -g --list --unsorted

# Show system information
[group("Info")]
system-info:
    @echo "Architecture: {{arch()}}"
    @echo "OS: {{os()}}"
    @echo "OS Family: {{os_family()}}"
    @echo "Current directory: {{invocation_directory()}}"
    @echo "Home directory: {{home_directory()}}"

# Show current date and time
[group("Info")]
now:
    @date '+%Y-%m-%d %H:%M:%S'

# Show disk usage
[group("Info")]
disk-usage:
    @df -h 2>/dev/null || df

# Show memory usage
[group("Info")]
memory:
    @if command -v free >/dev/null 2>&1; then \
        free -h; \
    elif [ "$(uname)" = "Darwin" ]; then \
        vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'; \
    else \
        echo "Memory info not available"; \
    fi

# Extract various archive formats
[group("Files")]
extract file:
    #!/usr/bin/env bash
    set -euo pipefail
    
    if [ ! -f "{{file}}" ]; then
        echo "Error: '{{file}}' is not a valid file" >&2
        exit 1
    fi
    
    echo "Extracting {{file}}..."
    case "{{file}}" in
        *.tar.bz2|*.tbz2) tar xjf "{{file}}" ;;
        *.tar.gz|*.tgz)   tar xzf "{{file}}" ;;
        *.tar.xz|*.txz)   tar xJf "{{file}}" ;;
        *.tar.zst)        tar --zstd -xf "{{file}}" ;;
        *.tar)            tar xf "{{file}}" ;;
        *.zip|*.ZIP)      unzip -q "{{file}}" ;;
        *.gz)             gunzip -k "{{file}}" ;;
        *.bz2)            bunzip2 -k "{{file}}" ;;
        *.xz)             unxz -k "{{file}}" ;;
        *.rar)            unrar x -y "{{file}}" ;;
        *.7z)             7z x -y "{{file}}" ;;
        *.Z)              uncompress "{{file}}" ;;
        *)                echo "Error: Don't know how to extract '{{file}}'" >&2; exit 1 ;;
    esac
    
    echo "✓ Extraction complete"

# Create archive from directory or file
[group("Files")]
archive target type="tar.gz":
    #!/usr/bin/env bash
    set -euo pipefail
    
    if [ ! -e "{{target}}" ]; then
        echo "Error: '{{target}}' does not exist" >&2
        exit 1
    fi
    
    name=$(basename "{{target}}")
    case "{{type}}" in
        tar.gz|tgz)  tar czf "${name}.tar.gz" "{{target}}" && echo "✓ Created ${name}.tar.gz" ;;
        tar.bz2|tbz) tar cjf "${name}.tar.bz2" "{{target}}" && echo "✓ Created ${name}.tar.bz2" ;;
        tar.xz|txz)  tar cJf "${name}.tar.xz" "{{target}}" && echo "✓ Created ${name}.tar.xz" ;;
        zip)         zip -qr "${name}.zip" "{{target}}" && echo "✓ Created ${name}.zip" ;;
        *)           echo "Error: Unknown archive type '{{type}}'" >&2; exit 1 ;;
    esac

# Find large files (default: >100M)
[group("Files")]
find-large size="100M":
    @find . -type f -size +{{size}} -exec ls -lh {} \; 2>/dev/null | awk '{ print $NF ": " $5 }'

# Show directory tree (requires tree command)
[group("Files")]
tree depth="3":
    @tree -L {{depth}} --dirsfirst -C 2>/dev/null || find . -maxdepth {{depth}} -type d | sed -e "s/[^-][^\/]*\//  /g" -e "s/^//" -e "s/-/|/"

# ===== Process Management =====
# Kill process using a specific port
[group("Process")]
killport port:
    #!/usr/bin/env bash
    set -euo pipefail
    
    if [ "$(uname)" = "Darwin" ]; then
        pids=$(lsof -ti:{{port}} 2>/dev/null || true)
    else
        pids=$(lsof -ti:{{port}} 2>/dev/null || fuser {{port}}/tcp 2>/dev/null || true)
    fi
    
    if [ -z "$pids" ]; then
        echo "No process found on port {{port}}"
    else
        echo "Killing process(es) on port {{port}}: $pids"
        kill -9 $pids
        echo "✓ Killed"
    fi

# List all processes using network ports
[group("Process")]
ports:
    @if [ "$(uname)" = "Darwin" ]; then \
        lsof -iTCP -sTCP:LISTEN -P -n | grep -v "^COMMAND"; \
    else \
        ss -tlnp 2>/dev/null || netstat -tlnp 2>/dev/null || echo "No suitable command found"; \
    fi

# Find process by name
[group("Process")]
find-process name:
    @ps aux | grep -i "{{name}}" | grep -v grep

# ===== Development =====
# Clean common build artifacts and caches
[group("Dev")]
clean:
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "Cleaning build artifacts..."
    dirs=(".venv" "venv" "node_modules" "target" "build" "dist" "__pycache__" ".pytest_cache" ".coverage" "*.egg-info")
    
    for dir in "${dirs[@]}"; do
        if [ -e "$dir" ]; then
            echo "  Removing $dir"
            rm -rf "$dir"
        fi
    done
    
    # Clean common file patterns
    find . -type f -name "*.pyc" -delete 2>/dev/null || true
    find . -type f -name ".DS_Store" -delete 2>/dev/null || true
    find . -type d -name "__pycache__" -delete 2>/dev/null || true
    
    echo "✓ Cleanup complete"

# Start a simple HTTP server in current directory
[group("Dev")]
serve port="8000":
    @echo "Starting HTTP server on http://localhost:{{port}}"
    @python3 -m http.server {{port}} 2>/dev/null || python -m SimpleHTTPServer {{port}}

# Create a new project directory with common structure
[group("Dev")]
init-project name type="python":
    #!/usr/bin/env bash
    set -euo pipefail
    
    if [ -d "{{name}}" ]; then
        echo "Error: Directory '{{name}}' already exists" >&2
        exit 1
    fi
    
    mkdir -p "{{name}}"
    cd "{{name}}"
    
    case "{{type}}" in
        python)
            touch README.md requirements.txt .gitignore
            mkdir -p src tests docs
            echo -e "# {{name}}\n" > README.md
            echo -e ".venv/\n__pycache__/\n*.pyc\n.coverage\n.pytest_cache/" > .gitignore
            ;;
        node|js)
            npm init -y >/dev/null
            touch README.md .gitignore
            mkdir -p src tests
            echo -e "node_modules/\n.env\ndist/\n*.log" > .gitignore
            ;;
        *)
            touch README.md .gitignore
            echo -e "# {{name}}\n" > README.md
            ;;
    esac
    
    git init >/dev/null
    echo "✓ Created project '{{name}}' with {{type}} structure"

# ===== Git Helpers =====
# Show git status for all repositories in subdirectories
[group("Git")]
git-status-all:
    @find . -type d -name ".git" -not -path "*/\.*" | while read gitdir; do \
        dir=$(dirname "$gitdir"); \
        echo -e "\n📁 $dir"; \
        git -C "$dir" status -s || echo "  Error checking status"; \
    done

# Update all git repositories in subdirectories
[group("Git")]
git-pull-all:
    @find . -type d -name ".git" -not -path "*/\.*" | while read gitdir; do \
        dir=$(dirname "$gitdir"); \
        echo -e "\n📁 Updating $dir..."; \
        git -C "$dir" pull || echo "  Error pulling"; \
    done

# ===== Network =====
# Test network connectivity
[group("Network")]
ping-test host="google.com" count="4":
    @ping -c {{count}} {{host}} 2>/dev/null || ping -n {{count}} {{host}}

# Show network interfaces
[group("Network")]
interfaces:
    @if command -v ip >/dev/null 2>&1; then \
        ip -br addr; \
    elif command -v ifconfig >/dev/null 2>&1; then \
        ifconfig -a | grep -E "^[a-zA-Z]|inet"; \
    else \
        echo "No suitable command found"; \
    fi

# Get public IP address
[group("Network")]
my-ip:
    @curl -s https://ipinfo.io/ip 2>/dev/null || curl -s https://icanhazip.com 2>/dev/null || echo "Failed to get IP"

# ===== System Control =====
# Reboot the system
[group("System")]
[confirm("Are you sure you want to reboot?")]
reboot:
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "Rebooting system..."
    if [ "$(uname)" = "Darwin" ]; then
        osascript -e 'tell app "System Events" to restart'
    elif command -v systemctl >/dev/null 2>&1; then
        sudo systemctl reboot
    elif command -v reboot >/dev/null 2>&1; then
        sudo reboot
    else
        echo "Error: Don't know how to reboot this system" >&2
        exit 1
    fi

# Shut down the system
[group("System")]
[confirm("Are you sure you want to shut down?")]
shutdown:
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "Shutting down system..."
    if [ "$(uname)" = "Darwin" ]; then
        osascript -e 'tell app "System Events" to shut down'
    elif command -v systemctl >/dev/null 2>&1; then
        sudo systemctl poweroff
    elif command -v shutdown >/dev/null 2>&1; then
        sudo shutdown -h now
    else
        echo "Error: Don't know how to shut down this system" >&2
        exit 1
    fi

# Update system packages
[group("System")]
update:
    #!/usr/bin/env bash
    set -euo pipefail
    
    echo "Updating system packages..."
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get upgrade -y
    elif command -v yum >/dev/null 2>&1; then
        sudo yum update -y
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu
    elif command -v brew >/dev/null 2>&1; then
        brew update && brew upgrade
    else
        echo "Error: Package manager not recognized" >&2
        exit 1
    fi
    echo "✓ Update complete"

# ===== Docker =====
# Remove unused Docker resources
[group("Docker")]
docker-clean:
    @echo "Cleaning Docker resources..."
    @docker system prune -f --volumes 2>/dev/null || echo "Docker not available"

# Show Docker disk usage
[group("Docker")]
docker-usage:
    @docker system df 2>/dev/null || echo "Docker not available"

# ===== Utilities =====
# Generate a secure random password
[group("Utils")]
password length="20":
    @if command -v openssl >/dev/null 2>&1; then \
        openssl rand -base64 32 | tr -d "=+/" | cut -c1-{{length}}; \
    else \
        < /dev/urandom tr -dc 'A-Za-z0-9!@#$%^&*()' | head -c{{length}}; echo; \
    fi

# Calculate SHA256 checksum of a file
[group("Utils")]
checksum file:
    @if [ -f "{{file}}" ]; then \
        if command -v sha256sum >/dev/null 2>&1; then \
            sha256sum "{{file}}"; \
        elif command -v shasum >/dev/null 2>&1; then \
            shasum -a 256 "{{file}}"; \
        else \
            echo "No SHA256 command available"; \
        fi; \
    else \
        echo "File '{{file}}' not found"; \
    fi

# Show weather for a location
[group("Utils")]
weather location="Ottawa,Canada":
    @curl -s "wttr.in/{{location}}?format=3" 2>/dev/null || echo "Failed to get weather"

# Convert timestamp to human readable format
[group("Utils")]
timestamp-to-date ts:
    @date -d @{{ts}} 2>/dev/null || date -r {{ts}} 2>/dev/null || echo "Invalid timestamp"
