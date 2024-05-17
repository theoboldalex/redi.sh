#!/usr/bin/env bash

if [ -z "$1" ]; then
    cat ./usage/client.txt
    exit 1
fi

HOST=$1
PORT=$2

source ./utils.sh

while true; do
    echo "Issue a command [GET, SET] (type 'exit' to quit):"
    read cmd
    if [ "$cmd" == "exit" ]; then
        break
    fi

    if validate_command "$cmd"; then
        echo "$cmd" | nc "$HOST" "$PORT"
    fi
done


