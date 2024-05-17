#!/usr/bin/env bash 

# this is the storage for all key value pairs. Pretty ain't it?
HASH_MAP=()
PORT=$1

if [ -z "$PORT" ]; then
    cat << EOF
    USAGE: ./server.sh <port>;

    OPTIONS:
    <port>;    Specify the port number (must be an integer between 1024 and 65535)

    EXAMPLES:
    ./server.sh 8080   Starts the service on port 8080
    ./server.sh 443    Starts the service on port 443 (typically used for HTTPS)

    NOTES:
    - Ensure the port number is not already in use.
    - Ports below 1024 require superuser privileges.
    - Valid port numbers range from 1024 to 65535.
EOF
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
            echo "Received input: $cmd"
        fi
    done > $N_PIPE)
done
