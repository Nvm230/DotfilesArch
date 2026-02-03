#!/bin/bash

# Check for tun0 interface
if ip addr show tun0 > /dev/null 2>&1; then
    # Extract IP address
    ip_addr=$(ip addr show tun0 | grep "inet " | awk '{print $2}' | cut -d/ -f1)
    echo "{\"text\": \"$ip_addr\", \"tooltip\": \"VPN Connected: $ip_addr\", \"class\": \"connected\", \"alt\": \"connected\"}"
else
    echo "{\"text\": \"Disconnected\", \"tooltip\": \"VPN Disconnected\", \"class\": \"disconnected\", \"alt\": \"disconnected\"}"
fi
