#!/bin/bash
# Refactored to support mise and dotter setup with modular execution
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

# Targets
TARGET_MISE=false
TARGET_DOTTER=false
TARGET_WINDOWS=false

# Function to display usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -n, --dry-run     Show commands without executing"
    echo "  --mise            Link mise config and run mise install"
    echo "  --dotter          Run dotter deploy"
    echo "  --windows         Copy Windows specific configs (if on WSL)"
    echo "  -h, --help        Show this help message"
}

# Parse arguments
HAS_TARGET=false
while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run)
            DRY_RUN=true
            shift
            ;;
        --mise)
            TARGET_MISE=true
            HAS_TARGET=true
            shift
            ;;
        --dotter)
            TARGET_DOTTER=true
            HAS_TARGET=true
            shift
            ;;
        --windows)
            TARGET_WINDOWS=true
            HAS_TARGET=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# If no target specified, enable all defaults
if [[ "$HAS_TARGET" == false ]]; then
    TARGET_MISE=true
    TARGET_DOTTER=true

    if uname -r | grep -qi microsoft; then
        TARGET_WINDOWS=true
    fi
fi

# Execute function
execute() {
    local cmd="$*"
    if [[ "$DRY_RUN" == true ]]; then
        echo "[DRY-RUN] $cmd"
    else
        echo "[EXEC] $cmd"
        eval "$cmd"
    fi
}

setup_mise() {
    echo "Setting up mise..."
    execute "mkdir -p ~/.config"
    execute "rm -rf ~/.config/mise"
    execute "ln -s \"$SCRIPT_DIR/settings/mise\" ~/.config/mise"
    execute "mise install"
}

setup_dotter() {
    echo "Running dotter deploy..."
    execute "dotter deploy"
}

setup_windows() {
    echo "copy to wezterm settings files for Windows"
    execute "cp -r \"$SCRIPT_DIR/settings/wezterm/wezterm.lua\" /mnt/c/Users/noguk/.config/wezterm/wezterm.lua"
}

# Main execution
if [[ "$TARGET_MISE" == true ]]; then
    setup_mise
fi

if [[ "$TARGET_DOTTER" == true ]]; then
    setup_dotter
fi

if [[ "$TARGET_WINDOWS" == true ]]; then
    setup_windows
fi
