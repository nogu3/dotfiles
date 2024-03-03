# tmux
rm -f ~/.tmux.conf
ln -s "`pwd`/settings/tmux/.tmux.conf" ~/.tmux.conf

# lazygit
mkdir -p ~/.config/lazygit
rm -f ~/.config/lazygit/config.yml
ln -s "`pwd`/settings/lazygit/config.yml" ~/.config/lazygit/config.yml

# neovim
mkdir -p ~/.config/nvim/lua
rm -f ~/.config/nvim/init.lua
ln -s "`pwd`/settings/nvim/init.lua" ~/.config/nvim/init.lua

rm -f ~/.config/nvim/lua/plugins
ln -s "`pwd`/settings/nvim/lua/plugins" ~/.config/nvim/lua/plugins

# zsh
rm -f ~/.zshrc
ln -s "`pwd`/settings/zsh/.zshrc" ~/.zshrc
