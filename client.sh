#!/usr/bin/env bash

if [ -z "$1" ]; then
cat << EOF
    USAGE: ./client.sh <host> <port>;

    OPTIONS:
      <host>;    Specify the host to connect to.
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

client_respond() {
   text="$1"
   echo "$1"
}

# Consider what we do when multiple clients connected to server
while true; do
    echo "Issue a command [GET, SET] (type 'exit' to quit):"
    read cmd
    if [ "$cmd" == "exit" ]; then
        break
    fi

    # NEEDS WORK
    if echo "$cmd" | grep -qvE "^(GET|SET)" ; then
        client_respond "Command '$cmd' is not a valid command"
    fi
    echo "$cmd" | nc "$HOST" "$PORT"
done


