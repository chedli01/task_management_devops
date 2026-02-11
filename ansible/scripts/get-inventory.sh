#!/bin/bash
set -e

echo "Generating Ansible inventory from Terraform outputs..."

# Get the script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Terraform directory
TERRAFORM_DIR="${PROJECT_ROOT}/terraform/environments/prod"
INVENTORY_FILE="${PROJECT_ROOT}/ansible/inventory/hosts.yml"

# Ensure inventory directory exists
mkdir -p "$(dirname "${INVENTORY_FILE}")"

cd "${TERRAFORM_DIR}"

# Get VM IP from Terraform
VM_IP=$(terraform output -raw vm_public_ip 2>/dev/null || echo "")

if [ -z "$VM_IP" ]; then
    echo "Error: Could not get VM IP from Terraform"
    echo "Make sure Terraform is deployed: cd terraform/environments/prod && terraform apply"
    exit 1
fi

echo "VM IP: $VM_IP"

# Create inventory file
cat > "${INVENTORY_FILE}" << EOF
---
all:
  children:
    production:
      hosts:
        taskmanager-vm:
          ansible_host: ${VM_IP}
          ansible_user: azureuser
          ansible_ssh_private_key_file: ~/.ssh/azure_taskmanager
          ansible_python_interpreter: /usr/bin/python3

  vars:
    ansible_connection: ssh
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
EOF

echo "Inventory created: ansible/inventory/hosts.yml"
echo ""
echo "Test connection:"
echo "  cd ansible"
echo "  ansible all -m ping"