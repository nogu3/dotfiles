FROM ubuntu:22.04

RUN apt update && \
    apt install -y neovim \
    tmux \
    curl \
    git

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

RUN git config --global --add safe.directory /root/dotfiles

