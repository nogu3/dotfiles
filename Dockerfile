FROM ubuntu:22.04

# amd64 or arm64
ARG ARCH=amd64
# x86_64 or arm64
ARG ARCH_ALIAS=x86_64

RUN apt update \
    && apt install -y \
    zsh \
    ripgrep \
    tmux \
    curl \
    git \
    exa \
    ruby \
    # require install solargraph
    ruby-dev \
    g++ \
    make \
    # require build neovim
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    build-essential

# install lsp and linter for ruby
RUN gem install \
    solargraph \
    rubocop

# install neovim
RUN git clone https://github.com/neovim/neovim \
    && cd neovim \
    && git checkout stable \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo \
    && make install

ENV PATH="$PATH:/opt/nvim-linux64/bin"

# install lazygit
# https://github.com/jesseduffield/lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
    && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${ARCH_ALIAS}.tar.gz" \
    && tar xf lazygit.tar.gz lazygit \
    && install lazygit /usr/local/bin \
    && rm -r lazygit lazygit.tar.gz

# install delta
RUN curl -Lo "delta.deb" https://github.com/dandavison/delta/releases/download/0.16.5/git-delta_0.16.5_${ARCH}.deb \
    && dpkg -i delta.deb \
    && rm delta.deb

# install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt install -y nodejs

# install jump
RUN curl -Lo "jump.deb" https://github.com/gsamokovarov/jump/releases/download/v0.51.0/jump_0.51.0_${ARCH}.deb \
    && dpkg -i jump.deb \
    && rm jump.deb

# create user
# https://qiita.com/Spritaro/items/602118d946a4383bd2bb
ARG USERNAME=sandbox
ARG GROUPNAME=sandbox
ARG UID=1000
ARG GID=1000

# create workdir
RUN mkdir -p /workspaces/$USERNAME \
    && chown ${UID}:${GID} /workspaces/${USERNAME} \
    && mkdir -p /workspaces/src \
    && chown ${UID}:${GID} /workspaces/src

RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /usr/bin/zsh -u $UID -g $GID $USERNAME

USER $USERNAME
WORKDIR /workspaces/$USERNAME

# copy init.sh
COPY --chown=${USERNAME}:${GROUPNAME} init.sh /workspaces/sandbox/init.sh
RUN chmod +x /workspaces/sandbox/init.sh \
    && ./init.sh

# copy settings
COPY --chown=${USERNAME}:${GROUPNAME} settings/ /workspaces/sandbox/settings/

