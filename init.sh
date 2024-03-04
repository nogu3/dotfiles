# tmux
rm -f ~/.tmux.conf
ln -s "`pwd`/settings/tmux/.tmux.conf" ~/.tmux.conf

# lazygit
mkdir -p ~/.config/lazygit
rm -f ~/.config/lazygit/config.yml
ln -s "`pwd`/settings/lazygit/config.yml" ~/.config/lazygit/config.yml

# neovim
mkdir -p ~/.config
rm -f ~/.config/nvim
ln -s "`pwd`/settings/nvim" ~/.config/nvim

# zsh
rm -f ~/.zshrc
ln -s "`pwd`/settings/zsh/.zshrc" ~/.zshrc
