#!/usr/bin/env bash 

# this is the storage for all key value pairs. Pretty ain't it?
HASH_MAP=()

# usage options
# running server requires args
# $1 = port to listen on
if [ -z "$1" ]; then
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

PORT=$1

# TODO: check port is not blocked or currently in use
nc -lvk "$PORT" | while read cmd; do
    # NEEDS WORK!
    if echo "$cmd" | grep -qvE "^(GET|SET)" ; then
        echo "Command $cmd is not a valid command"
    fi

    echo "Received input: $cmd"
done
