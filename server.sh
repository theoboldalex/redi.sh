#!/usr/bin/env bash 

# this is the storage for all key value pairs. Pretty ain't it?
HASH_MAP=()
PORT=$1

if [ -z "$PORT" ]; then
    cat ./usage/server.txt
    exit 1
fi

source ./utils.sh

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
                log "$cmd"
            else
                # Set value for given key
                log "$cmd"
            fi
        fi
    done > $N_PIPE)
done
