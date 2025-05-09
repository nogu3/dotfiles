### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

### Zinit 
zinit ice wait'!0'

# colorschema
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# utility
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting


### import .z~
# import .zprofile
ZPROFILE="${HOME}/.zprofile"

if [[ -f "$ZPROFILE" ]]; then
  source "$ZPROFILE"
fi

# import local setting
source "${HOME}/.zshrc_local"


### color theme for eza
# theme dracura for eza
# https://draculatheme.com/exa
export EXA_COLORS="uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:"

# theme iceberg-dark
export LS_COLORS="$(vivid generate iceberg-dark)"


### setup utility
# add zoxide bin path
export PATH=$PATH:~/.local/bin

# setup zoxide
eval "$(zoxide init zsh)"

# setup fzf
source <(fzf --zsh)
# select repository with fzf
fzf-ghq-widget() {
  local selected_dir=$(ghq list | fzf)
  if [[ -n "$selected_dir" ]]; then
    cd "$HOME/ghq/$selected_dir"
    zle reset-prompt
  fi
}
zle -N fzf-ghq-widget
bindkey '^g' fzf-ghq-widget

# setup tmux
export TMUX_TMPDIR=~/.tmux/sessions
mkdir -p $TMUX_TMPDIR

# tmux start session or attach session when tmux installed.
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi


# setup lazygit
if [[ "$(uname)" == "Darwin" ]]; then
  export XDG_CONFIG_HOME=~/.config
else
  export LG_CONFIG_PATH=~/.config/lazygit/config.yml
fi

# setup my scripts
export PATH=$PATH:~/.scripts


### aliases
alias ls='eza -a --icons'
alias ll='eza -lag --sort=type --icons --header --time-style=long-iso'

# tmux
alias ta="tmux a"

# nvim
# main
alias nv="nvh"
# nvim on host
nvh() {
  rm -f "$(pwd)/.nvim-server.pipe"
  nvim --listen "$(pwd)/.nvim-server.pipe" $@
}

# docker
du() {
  docker compose up -d $@
}

dd() {
  docker compose down $@
}

de() {
  docker compose exec $@ bash
}

dez() {
  docker compose exec $@ zsh
}
alias dl="docker compose logs -f"
alias dp="docker ps -a"

# git
alias gp="git pull"
alias gf="git fetch"
