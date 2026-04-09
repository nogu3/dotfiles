# Install Fisher if it's not installed
if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end

# Install pure theme and plugins using fisher (if not already installed)
# In fish, autosuggestions and syntax highlighting are built-in, but we can enhance it
if not type -q _pure_prompt_new_line
    fisher install pure-fish/pure
end

# import profile (concept equivalent in fish)
# fish doesn't use .zprofile, but we can source a generic profile if needed
# Typically environment variables are set in config.fish or via `set -U`

# import local setting
if test -f "$HOME/.config/fish/config_local.fish"
    source "$HOME/.config/fish/config_local.fish"
end

# color theme for eza
# theme dracula for eza
# https://draculatheme.com/exa
set -x EXA_COLORS "uu=36:gu=37:sn=32:sb=32:da=34:ur=34:uw=35:ux=36:ue=36:gr=34:gw=35:gx=36:tr=34:tw=35:tx=36:"

# theme iceberg-dark
if type -q vivid
    set -x LS_COLORS (vivid generate iceberg-dark)
end

# setup utility
if type -q mise
    mise activate fish | source
end

# setup zoxide
if type -q zoxide
    zoxide init fish | source
end

# setup fzf
if type -q fzf
    fzf --fish | source
end

# select repository with fzf
function fzf-ghq-widget
    set selected_dir (ghq list | fzf)
    if test -n "$selected_dir"
        cd "$HOME/ghq/$selected_dir"
        commandline -f repaint
    end
end
bind \cg fzf-ghq-widget
# alias for quick access
alias g="fzf-ghq-widget"

# setup lazygit
if test (uname) = "Darwin"
    set -x XDG_CONFIG_HOME ~/.config
else
    set -x LG_CONFIG_PATH ~/.config/lazygit/config.yml
end

# setup my scripts
set -x PATH $PATH ~/.scripts

# aliases
alias ls='eza -a --icons'
alias ll='eza -lag --sort=type --icons --header --time-style=long-iso'

alias dl="docker compose logs -f"
alias dp="docker ps -a"

# git
alias gp="git pull"
alias gf="git fetch"
