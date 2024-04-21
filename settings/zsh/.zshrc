# import .zprofile
ZPROFILE="${HOME}/.zprofile"

if [[ -f "$ZPROFILE" ]]; then
  source "$ZPROFILE"
fi

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

zinit ice wait'!0'
# colorschema
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

# utility
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting

# setup jump
eval "$(jump shell zsh)"

# aliases
alias ls='exa -a --icons'
alias ll='exa -la --sort=type --icons --header --time-style=long-iso'

# nvim
# main
alias nv="nvd"
# nvim on host
nvh() {
  nvim --listen /tmp/nvim-server.pipe $@
}

# nvim on docker
nvd() {
  docker run -it --rm \
    -v codecraft_home:/home/sandbox \
    -v .:/workspaces/src \
    -v /tmp/tmux-1000:/tmp/tmux-1000 \
    -w /workspaces/src \
    -e TMUX=$TMUX \
    -e HOST_UID=$(id -u $USER) \
    -e HOST_GID=$(id -g $USER) \
    codecraft \
    nvim --listen /tmp/nvim-server.pipe $@
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
