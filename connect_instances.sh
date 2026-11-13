#!/bin/bash

# SSH configuration
KEY_FILE="$SSH_KEY"
USERNAME="$SSH_USER"

# List your instance IP addresses
INSTANCE_IPS=(
    "10.0.1.10"
    "10.0.2.11"
    "10.0.2.12"
    "10.0.2.13"
)

# Jenkins provides these variables
if [[ -z "$KEY_FILE" ]]; then
    echo "ERROR: KEY_FILE is not available"
    exit 1
fi

# Check that the private key exists
if [[ ! -f "$KEY_FILE" ]]; then
    echo "ERROR: Private key not found: $KEY_FILE"
    exit 1
fi

# Set correct key permissions
chmod 400 "$KEY_FILE"

# Connect to each instance
for IP in "${INSTANCE_IPS[@]}"; do
    echo "===================================="
    echo "Connecting to $IP ..."

    if ssh \
        -i "$KEY_FILE" \
        -o ConnectTimeout=10 \
        -o StrictHostKeyChecking=accept-new \
        "$USERNAME@$IP" \
        "echo 'SSH connection successful on $(hostname)'"
    then
        echo "SUCCESS: $IP"
    else
        echo "FAILED: $IP"
        exit 1
    fi
done

echo "===================================="
echo "All connection attempts completed."