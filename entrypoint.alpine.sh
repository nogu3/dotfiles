#!/bin/sh

# stop run script when error
set -e

USER_NAME="sandbox"
GROUP_NAME="sandbox-group"

USER_ID=${HOST_UID:-1000}
GROUP_ID=${HOST_GID:-1000}

usermod -u $USER_ID -o $USER_NAME >/dev/null
groupmod -o -g $GROUP_ID $GROUP_NAME >/dev/null

chown -R $USER_NAME:$GROUP_NAME /workspaces/src
chown -R $USER_NAME:$GROUP_NAME /home/$USER_NAME
chown -R $USER_NAME:$GROUP_NAME /tmp/codecraft

su-exec $USER_NAME /tmp/codecraft/init.sh

exec su-exec $USER_NAME "$@"
