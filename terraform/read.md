# Task Manager Infrastructure

Production-grade Terraform infrastructure for Task Manager application.

## Architecture

### Phase 1: Single VM (Current)
- 1 Azure VM (Standard_D2s_v3)
- VNet with subnets for app and data tiers
- Storage account for backups
- Managed identity for secure access
- NSG with restrictive rules

### Phase 2: Load Balanced (Future)
- Azure Load Balancer
- Multiple VMs (2+)
- Managed PostgreSQL
- Auto-scaling

## Prerequisites

1. **Azure CLI**
```bash
   curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
   az login
```

2. **Terraform**
```bash
   wget https://releases.hashicorp.com/terraform/1.7.0/terraform_1.7.0_linux_amd64.zip
   unzip terraform_1.7.0_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
```

3. **SSH Key**
```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_taskmanager
```

## Quick Start

### Step 1: Configure

Edit `environments/prod/terraform.tfvars`:
```hcl
admin_source_ip      = "YOUR_IP/32"  # Get: curl ifconfig.me
admin_ssh_public_key = "YOUR_SSH_PUBLIC_KEY"  # From: cat ~/.ssh/azure_taskmanager.pub
owner_email          = "your@email.com"
```

### Step 2: Deploy
```bash
# Initialize
./scripts/init.sh

# Plan
./scripts/plan.sh

# Apply
./scripts/apply.sh
```

### Step 3: Connect
```bash
# SSH to VM
ssh azureuser@<VM_IP>

# Or use helper script
./scripts/get-vm-ip.sh
```

## Cost Estimate

- VM (Standard_D2s_v3): ~$20/month
- Storage (LRS): ~$2/month
- Public IP: ~$3/month
- **Total: ~$25/month**

## Scaling Strategy

### Current Capacity
- Handles: ~1,000 concurrent users
- CPU: 2 vCPU
- RAM: 4GB

### Scaling Triggers
- CPU > 70% for 10+ minutes
- Memory > 80% for 10+ minutes
- Response time > 1 second (p95)

### Scaling Actions
1. Vertical: Upgrade to Standard_B4ms (4 vCPU, 16GB)
2. Horizontal: Deploy load-balanced module
3. Database: Migrate to Azure PostgreSQL

## Security

- ✅ SSH key authentication only
- ✅ Restrictive NSG rules
- ✅ Managed identity (no credentials)
- ✅ Firewall enabled (UFW)
- ✅ Fail2ban for brute force protection
- ✅ Automatic security updates

## Disaster Recovery

### Backup
- Database: Daily automated backups to Azure Storage
- Application: Code in Git

### Recovery Time Objective (RTO)
- Complete rebuild: 15 minutes
- Database restore: 5 minutes
- **Total: 20 minutes**

### Recovery Process
```bash
# 1. Provision infrastructure
terraform apply

# 2. Configure server (Ansible - next phase)
ansible-playbook deploy.yml

# 3. Restore database
./scripts/restore-backup.sh latest
```

## Outputs
```bash
terraform output
```

Available outputs:
- `vm_public_ip` - Public IP address
- `ssh_command` - SSH connection command
- `storage_account_name` - Storage account name
- `managed_identity_client_id` - For application auth

## Destroy
```bash
./scripts/destroy.sh
```

**WARNING:** This destroys all infrastructure!