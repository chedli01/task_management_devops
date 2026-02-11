#!/bin/bash
set -e

# This wrapper passes GitHub Actions secrets to your original deploy script

# Read vault password from environment variable
VAULT_PASS=${VAULT_PASS}
IMAGE_TAG=${IMAGE_TAG}

if [ -z "$VAULT_PASS" ] || [ -z "$IMAGE_TAG" ]; then
  echo "VAULT_PASS and IMAGE_TAG must be set!"
  exit 1
fi

# Export IMAGE_TAG so the original script can read it
export IMAGE_TAG

# Run original deploy script, passing the vault password
ansible-playbook playbooks/deploy.yml --ask-vault-pass <<< "$VAULT_PASS"


echo ""
echo "Application deployed!"
echo ""
echo "Access your application:"
VM_IP=$(grep ansible_host inventory/hosts.yml | awk '{print $2}')
echo "  http://$VM_IP"