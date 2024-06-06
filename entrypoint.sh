#!/bin/sh

# stop run script when error
set -e

# chown -R codecraft:codecraft /workspaces/src

# su-exec codecraft /tmp/codecraft/init.sh

exec su-exec codecraft "$@"
