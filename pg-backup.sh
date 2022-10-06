#!/bin/sh
#
# usage:
# ./path/to/pg-backup.sh PG_URL SAS_URL

set -e

dbname="$(echo "$1" | sed 's/.*\///')"
filename="$(date +"%Y-%m-%d_%H:%M:%S").sql"

pg_dump "$1" | azcopy cp "$(echo "$2" | sed "s/?/\/$dbname\/$filename?/")" --from-to PipeBlob
