#!/usr/bin/env bash

if [[ -n $1 ]]; then
	echo "Usage: ./deploy.sh DOCKER.ENV"
	exit
fi

if [[ -n $SERVER_PATH ]]; then
	# Wireguard
	mkdir -p "${SERVER_PATH}/wireguard/config"
	# Obsidian
	mkdir -p "${SERVER_PATH}/obsidian/data"
else
	echo "Server path not set"
fi
