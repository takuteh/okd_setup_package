#!/bin/sh

ask_yes_no() {
    while true; do
        echo -n "$* [y/n]:"
        read ANS
        case $ANS in
        [Yy]*)
            return 0
            ;;
        [Nn]*)
            return 1
            ;;
        *)
            echo "Input y or n!"
            ;;
        esac
    done
}

if command -v docker-compose &>/dev/null; then
    COMPOSE="docker-compose"
elif docker compose version &>/dev/null; then
    COMPOSE="docker compose"
fi

set -a
. ./configs/okd_version.env
set +a
if ask_yes_no "OKD Version:${OKD_VERSION} - is this correct?"; then
	mkdir ./output
	cp ./configs/agent-config.yaml ./configs/install-config.yaml ./output
	$COMPOSE -f ./build/docker-compose.yaml up
else 
	echo "Aborting..."
fi
