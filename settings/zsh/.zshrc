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

### color theme for eza
# theme dracura for eza
# https://draculatheme.com/exa
export EXA_COLORS="uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:"

# theme iceberg-dark
export LS_COLORS="$(vivid generate iceberg-dark)"


### setup utility
export PATH=$PATH:~/.local/bin
eval "$(mise activate zsh)"
# mise activate はバージョン付き install パスを PATH に入れるため、herdr サーバー等が
# 環境をスナップショットすると mise upgrade 後にそのパスが消えて古い野良バイナリに
# フォールバックする。バージョン非依存の shims を前置してフォールバック先を固定する
# (対話シェルでは activate の動的パスが優先されるので shims は実質使われない)
export PATH="$HOME/.local/share/mise/shims:$PATH"
# eval "$(flox activate -d ~ -m run)"

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
# not working bindkey for warp
alias g="fzf-ghq-widget"

# setup lazygit
if [[ "$(uname)" == "Darwin" ]]; then
  export XDG_CONFIG_HOME=~/.config
else
  export LG_CONFIG_PATH=~/.config/lazygit/config.yml
fi

# setup my scripts
export PATH=$PATH:~/.scripts

# Claude Code: マウス制御を完全に無効化し、選択/コピーをターミナル(WezTerm)に任せる
export CLAUDE_CODE_DISABLE_MOUSE=1
# Claude Code: alternate screen を無効化し、通常のスクロールバックに出力する
export CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN=1

# import local setting
source "${HOME}/.zshrc_local"

### aliases
alias ls='eza -a --icons'
alias ll='eza -lag --sort=type --icons --header --time-style=long-iso'

alias dl="docker compose logs -f"
alias dp="docker ps -a"

# git
alias gp="git pull"
alias gf="git fetch"

# claude
alias claude='claude --permission-mode auto'

# 1Password SSH agent (WSL2)
# ssh/scp/ssh-add wrapper が /usr/bin/* より優先されるよう prepend
if [[ "$(uname -r)" == *microsoft* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# SSH ログイン時は forwarded agent socket を安定パスに symlink する。
# herdr のペインは herdr デーモンの環境を継承していて SSH_CONNECTION も
# forwarded SSH_AUTH_SOCK も持たないため、wrapper (settings/wsl/ssh) は
# この安定パスの生存を見て forwarded agent / ssh.exe を切り替える
if [[ -n "$SSH_CONNECTION" && -S "$SSH_AUTH_SOCK" && "$SSH_AUTH_SOCK" != "$HOME/.ssh/agent.sock" ]]; then
  ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/agent.sock"
  # op wrapper (settings/wsl/op) が接続元に ssh で戻って op を実行するための記録。
  # agent.sock が生きている間だけ有効とみなす
  print -r -- "${SSH_CONNECTION%% *}" > "$HOME/.ssh/op-client"
fi
