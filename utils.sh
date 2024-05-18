#!/usr/bin/env bash 

validate_command() {
    local cmd="$1"
    # who needs scalability?
    command_validation="^(GET \w+|SET \w+ '.*')$"

    # NEEDS WORK
    if echo "$cmd" | grep -qvE "$command_validation" ; then
        echo "Command '$cmd' is not a valid command"
        return 1
    fi

    return 0
}

log() {
    local input="$1"

    echo "Received: $input"
}

setup_temp_fs() {
    if [[ `uname` == 'Darwin' ]]; then
        # macos tmpfs
        echo "mac"
    else
        # linux ramfs
        echo "linux"
    fi
}
