#!/bin/sh

# stop run script when error
set -e

USER_NAME="sandbox"

USER_ID=${HOST_UID:-1000}
GROUP_ID=${HOST_GID:-1000}

usermod -u $USER_ID -o $USER_NAME > /dev/null 2>&1
groupmod -g $GROUP_ID $USER_NAME

gosu $USER_NAME /tmp/codecraft/init.sh

exec gosu $USER_NAME "$@"

