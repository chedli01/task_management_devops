#!/bin/bash
set -e

cd "$(dirname "$0")/../environments/prod"

IP=$(terraform output -raw vm_public_ip 2>/dev/null || echo "Not deployed")
SSH_CMD=$(terraform output -raw ssh_command 2>/dev/null || echo "Not deployed")

echo "VM Public IP: $IP"
echo "SSH Command: $SSH_CMD"