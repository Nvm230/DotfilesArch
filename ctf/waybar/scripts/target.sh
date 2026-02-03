#!/bin/bash

target_file="$HOME/.config/bin/target"

if [ -f "$target_file" ]; then
    ip_address=$(cat "$target_file" | awk '{print $1}')
    machine_name=$(cat "$target_file" | awk '{print $2}')

    if [ -n "$ip_address" ] && [ -n "$machine_name" ]; then
        echo "{\"text\": \"$ip_address - $machine_name\", \"tooltip\": \"Target: $machine_name ($ip_address)\", \"class\": \"active\"}"
    else
        echo "{\"text\": \"No target\", \"tooltip\": \"No active target set\", \"class\": \"inactive\"}"
    fi
else
    echo "{\"text\": \"No target\", \"tooltip\": \"Target file not found\", \"class\": \"inactive\"}"
fi
