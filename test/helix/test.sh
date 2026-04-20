#!/bin/bash
set -e

check() {
    LABEL=$1
    shift
    echo -n "Checking $LABEL... "
    if "$@" > /dev/null 2>&1; then
        echo "Passed!"
    else
        echo "Failed!"
        exit 1
    fi
}

check "helix version" hx --version
check "ripgrep version" rg --version
check "fd version" fd --version
check "lazygit version" lazygit --version
check "config file exists" test -f $HOME/.config/helix/config.toml
check "theme file exists" test -f $HOME/.config/helix/themes/rose_pine_moon_transparent.toml

echo "All tests passed!"
