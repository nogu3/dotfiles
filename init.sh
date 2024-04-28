#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# tmux
rm -f ~/.tmux.conf
ln -s "$SCRIPT_DIR/settings/tmux/.tmux.conf" ~/.tmux.conf

# lazygit
mkdir -p ~/.config/lazygit
rm -f ~/.config/lazygit/config.yml
ln -s "$SCRIPT_DIR/settings/lazygit/config.yml" ~/.config/lazygit/config.yml

# neovim
mkdir -p ~/.config
rm -f ~/.config/nvim
ln -s "$SCRIPT_DIR/settings/nvim" ~/.config/nvim

# zsh
# common
rm -f ~/.zshrc
ln -s "$SCRIPT_DIR/settings/zsh/.zshrc" ~/.zshrc

# specific
rm -f ~/.zshrc_local
ln -s "$SCRIPT_DIR/settings/zsh/.zshrc_local" ~/.zshrc_local
