#!/bin/bash
set -e

echo "Setting up Task Manager server..."

cd "$(dirname "$0")/.."

# # Generate inventory
./scripts/get-inventory.sh

# Run setup playbook
ansible-playbook playbooks/setup.yml

echo ""
echo "✅ Server setup complete!"
echo ""
echo "Next step: Deploy application"
echo "  ./scripts/deploy.sh"