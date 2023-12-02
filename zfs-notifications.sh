#!/bin/sh
#
# notify when zfs pool is not healthy

POOL=nas

set -e
cd -P -- "$(dirname -- "$0")"

if [ "$(zpool status $POOL -x)" != "pool '$POOL' is healthy" ]; then
	zpool status | ./slack-pipe.sh
fi
