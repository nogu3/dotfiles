FROM ubuntu:22.04

RUN apt update \
    && apt install -y \
    zsh \
    tmux \
    curl \
    git \
    ruby \
    # require install solargraph
    ruby-dev \
    g++ \
    make

# install lsp and linter
RUN gem install \
    solargraph \
    rubocop

# install neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux64.tar.gz

ENV PATH="$PATH:/opt/nvim-linux64/bin"

# https://github.com/jesseduffield/lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin \
    && rm -r lazygit lazygit.tar.gz

# install delta
RUN curl -Lo "delta.deb" https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_amd64.deb \
    && dpkg -i delta.deb \
    && rm delta.deb

# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt install -y nodejs

# install oh-my-zsh 
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
#    && git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions \
#    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# setup entrypoint 
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# create user
# https://qiita.com/Spritaro/items/602118d946a4383bd2bb
ARG USERNAME=sandbox
ARG GROUPNAME=sandbox
ARG UID=1000
ARG GID=1000

# create workdir
RUN mkdir -p /workspaces/$USERNAME \
    && chown ${UID}:${GID} /workspaces/${USERNAME}

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /usr/bin/zsh -u $UID -g $GID $USERNAME

USER $USERNAME
WORKDIR /workspaces/$USERNAME

