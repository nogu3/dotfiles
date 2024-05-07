FROM alpine:3.19.1

RUN apk update \
  && apk add --no-cache \
  # editor
  neovim \
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
  su-exec \
  shadow \
  nodejs \
  npm \
  # programming
  python3 \
  rust \
  cargo \
  ruby \
  ruby-dev \
  g++ \
  make

RUN cargo install --root /usr/local \
  vivid \
  eza

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

USER ${USER_NAME}

RUN chmod +x /tmp/codecraft/init.sh \
  && /tmp/codecraft/init.sh

