#!/usr/bin/env bash 

# this is the storage for all key value pairs. Pretty ain't it?
PORT=$1
MOUNT_DIR="/private/tmp/redish"

if [ -z "$PORT" ]; then
    cat ./usage/server.txt
    exit 1
fi

source ./utils.sh
mkdir -p $MOUNT_DIR
# Shitty MacOS - Need to fix this!
mount_tmpfs -o size=100M $MOUNT_DIR

N_PIPE=/tmp/redish_pipe
if [[ ! -p $N_PIPE ]]; then
    mkfifo $N_PIPE
fi

while true; do
    cat $N_PIPE |
    nc -lvk "$PORT" > >(while read -r cmd; do
        if validate_command "$cmd"; then
            if echo "$cmd" | grep -qE "^GET"; then
                # Get data for given key if available
                cd $MOUNT_DIR
                kvp=$(echo "$cmd" | sed 's/^GET //')
                key="${kvp%% *}"
                cat "$key"
                cd - >/dev/null 2>&1
                # log "$cmd"
            else
                # Set value for given key
                cd $MOUNT_DIR
                kvp=$(echo "$cmd" | sed 's/^SET //')
                key="${kvp%% *}"
                value="${kvp#* }"
                echo "$(echo "$value" | sed "s/^'//;s/'$//")" > "$key"
                cd - >/dev/null 2>&1
                # log "$cmd"
            fi
        fi
    done > $N_PIPE)
done
