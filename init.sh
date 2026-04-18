#!/bin/bash
# Refactored to support mise and dotter setup with modular execution
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DRY_RUN=false

# Targets
TARGET_MISE=false
TARGET_DOTTER=false
TARGET_CLAUDE_SKILLS=false

# Function to display usage
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -n, --dry-run     Show commands without executing"
    echo "  --mise            Link mise config and run mise install"
    echo "  --dotter          Run dotter deploy"
    echo "  --claude-skills   Install/update Claude Code skills from GitHub"
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
        --claude-skills)
            TARGET_CLAUDE_SKILLS=true
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
    TARGET_CLAUDE_SKILLS=true
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

# Helper function to execute command in the available user shell
execute_in_user_shell() {
    local cmd="$*"
    if type fish >/dev/null 2>&1; then
        execute "fish -c '$cmd'"
    elif type zsh >/dev/null 2>&1; then
        execute "zsh -c 'source ~/.zshrc && $cmd'"
    else
        execute "$cmd"
    fi
}

setup_mise() {
    echo "Setting up mise..."
    execute "mkdir -p ~/.config"
    execute "rm -rf ~/.config/mise"
    execute "ln -s \"$SCRIPT_DIR/settings/mise\" ~/.config/mise"
    execute_in_user_shell "mise install"
}

setup_dotter() {
    echo "Running dotter deploy..."
    execute_in_user_shell "mise exec -- dotter deploy"
}

setup_claude_skills() {
    echo "Installing/updating Claude Code plugins..."
    execute "claude plugin marketplace add InterfaceX-co-jp/genshijin --scope user"
    execute "claude plugin install genshijin@genshijin --scope user"
}

# Main execution
if [[ "$TARGET_MISE" == true ]]; then
    setup_mise
fi

if [[ "$TARGET_DOTTER" == true ]]; then
    setup_dotter
fi

if [[ "$TARGET_CLAUDE_SKILLS" == true ]]; then
    setup_claude_skills
fi
