#!/bin/bash
set -e

echo "Deploying Task Manager application..."

cd "$(dirname "$0")/.."

Generate inventory (in case IP changed)
./scripts/get-inventory.sh

# Run deployment playbook
ansible-playbook playbooks/deploy.yml --ask-vault-pass

echo ""
echo "Application deployed!"
echo ""
echo "Access your application:"
VM_IP=$(grep ansible_host inventory/hosts.yml | awk '{print $2}')
echo "  http://$VM_IP"