#! /usr/bin/env bash

## <config>
SRC_DIR="$HOME/.configs-shared"
DEF_HSTS="srv1 srv2 srv3 srv4 srv5"
DST_DIR="/var/sync"
DST_USR="root" # oops
## </config>

DST_HSTS="${*}"

if [ -z "${DST_HSTS}" ]; then
    DST_HSTS="${DEF_HSTS}"
    echo -en "\n>>> Using default list of hosts: ${DST_HSTS}"
else
    echo -en "\n>>> Using provided list of hosts: ${DST_HSTS}"
fi

for host in ${DST_HSTS}; do
    echo -en "\n\n| HOST: ${host}"
    echo -en "\n-----------------------------------\n"
    set -v
    rsync \
        --recursive --delete --copy-links \
        --chmod=Da+rx,o+w,Fa+r,o+w --no-o --no-g \
        --stats \
        "${SRC_DIR}/" "${DST_USR}@${host}:${DST_DIR}/"
    set +v
done

echo -en "\n"

