#!/bin/zsh
SCRIPT_DIR="${0:a:h}"

if uname -r | grep -qi microsoft; then
  OS="WINDOWS"
else
  OS="LINUX"
fi

# lazygit
# mkdir -p ~/.config/lazygit
# rm -f ~/.config/lazygit/config.yml
# ln -s "$SCRIPT_DIR/settings/lazygit/config.yml" ~/.config/lazygit/config.yml

# neovim
# mkdir -p ~/.config
# rm -f ~/.config/nvim
# ln -s "$SCRIPT_DIR/settings/zenvim" ~/.config/nvim

# zsh
# common
# rm -f ~/.zshrc
# ln -s "$SCRIPT_DIR/settings/zsh/.zshrc" ~/.zshrc

# specific
# rm -f ~/.zshrc_local
# ln -s "$SCRIPT_DIR/settings/zsh/.zshrc_local" ~/.zshrc_local

# scripts
# rm -f ~/.scripts
# ln -s "$SCRIPT_DIR/.scripts" ~/.scripts

if [[ $OS = "WINDOWS" ]]; then
  echo "copy to wezterm settings files for Windows"
  cp -r "$SCRIPT_DIR/settings/wezterm/wezterm.lua" /mnt/c/Users/noguk/.config/wezterm/wezterm.lua
else
  # TODO fix ln
fi
