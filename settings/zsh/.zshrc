# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
)

# setup zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# import .zprofile
ZPROFILE="${HOME}/.zprofile"

if [[ -f "$ZPROFILE" ]]; then
  source "$ZPROFILE"
fi

# setup jump
eval "$(jump shell)"

# aliases
alias nv="nvim"
alias sandbox="cd /workspaces/sandbox"
alias src="cd /workspaces/src"
