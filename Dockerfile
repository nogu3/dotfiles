FROM rust:alpine3.19 AS rust-library

RUN apk update \
  && apk add --no-cache \
  build-base

RUN cargo install --root /usr/local \
  vivid \
  eza

FROM alpine:3.19.1 AS neovim-builder

RUN apk update \
  && apk add --no-cache \
  git \
  build-base \
  cmake \
  coreutils \
  curl \
  unzip \
  gettext-tiny-dev

RUN git clone https://github.com/neovim/neovim /neovim

WORKDIR /neovim

RUN git checkout v0.10.0 \
  && make CMAKE_BUILD_TYPE=Release \
  && make install DESTDIR=/neovim/build

FROM alpine:3.19.1
COPY --from=neovim-builder /neovim/build/usr/local /usr/local
COPY --from=rust-library /usr/local/bin/vivid /usr/local/bin/vivid
COPY --from=rust-library /usr/local/bin/eza /usr/local/bin/eza

RUN apk update \
  && apk add --no-cache \
  # utility
  zsh \
  ripgrep \
  fd \
  delta \
  curl \
  zoxide \
  tmux \
  unzip \
  wget \
  # git
  git \
  lazygit \
  github-cli \
  # use docker
  # using groupadd
  shadow \
  # programming
  ruby \
  ruby-dev \
  # require solargraph
  make \
  g++

ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
ARG GROUP_NAME=sandbox-group

RUN groupadd -o -g ${GROUP_ID} $GROUP_NAME \
  && adduser -u ${USER_ID} -s $(which zsh) -D -G $GROUP_NAME $USER_NAME

# create workdir
RUN install -m 770 -o ${USER_NAME} -g ${GROUP_NAME} -d \
  /workspaces/src \
  /home/${USER_NAME}/.tmux

# copy init.sh
COPY --chown=${USER_NAME}:${GROUP_NAME} init.sh /tmp/codecraft/init.sh
# copy settings
COPY --chown=${USER_NAME}:${GROUP_NAME} settings/ /tmp/codecraft/settings/
# TODO copy scripts

USER ${USER_NAME}

RUN chmod +x /tmp/codecraft/init.sh \
  && /tmp/codecraft/init.sh

