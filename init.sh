#!/bin/zsh
SCRIPT_DIR="${0:a:h}"

if uname -r | grep -qi microsoft; then
  OS="WINDOWS"
elif uname -s | grep -qi darwin; then
  OS="MACOS"
else
  OS="LINUX"
fi

# tmux
rm -f ~/.tmux.conf
ln -s "$SCRIPT_DIR/settings/tmux/.tmux.conf" ~/.tmux.conf

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
  echo "copy to alacritty setting files for Windows"

  cp -r "$SCRIPT_DIR/settings/alacritty/windows/alacritty.toml" /mnt/c/Users/noguk/AppData/Roaming/alacritty/alacritty.toml
  cp -r "$SCRIPT_DIR/settings/alacritty/extensions/" /mnt/c/Users/noguk/AppData/Roaming/alacritty/

  echo "copy to wezterm settings files for Windows"
  cp -r "$SCRIPT_DIR/settings/wezterm/wezterm.lua" /mnt/c/Users/noguk/.config/wezterm/wezterm.lua
elif [[ $OS = "MACOS" ]]; then
  echo "Setting up mise brew-backend for macOS..."
  BREW_TOOLS=("jq" "ripgrep" "fd" "fzf" "bat" "delta" "zoxide" "eza" "gh" "ghq" "git-delta" "starship" "yazi" "lazygit")

  for tool in "${BREW_TOOLS[@]}"; do
      echo "Linking brew-backend for $tool"
      mise plugin link "$tool" "$SCRIPT_DIR/settings/mise/plugins/brew-backend"
  done
else
  :
  # TODO fix ln
fi
