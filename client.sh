#!/usr/bin/env bash

if [ -z "$1" ]; then
cat << EOF
    USAGE: ./client.sh <port>;

    OPTIONS:
      <port>;    Specify the port number (must be an integer between 1024 and 65535)

    EXAMPLES:
      ./client.sh localhost 8080   Starts the client on localhost port 8080

    NOTES:
      - Ensure the port number is not already in use.
      - Ensure the port number matches that of the server.
EOF
    exit 1
fi

HOST=$1
PORT=$2

nc -v "$HOST" "$PORT"


