#!/bin/sh
# entrypoint.sh

# stop run script when error
set -e

sh init.sh

# run CMD
exec "$@"
