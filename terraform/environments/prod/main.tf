terraform {
  required_version = ">= 1.0"

 
  backend "azurerm" {
    resource_group_name  = "taskmanager-prod-rg"
    storage_account_name = "taskmanagerprodexxarbit"
    container_name       = "terraform-state"
    key                  = "prod.terraform.tfstate"
  }
}
module "infrastructure" {
  source = "../../modules/single-vm"

  project_name         = var.project_name
  environment          = var.environment
  location             = var.location
  vm_size              = var.vm_size
  admin_username       = var.admin_username
  admin_source_ip      = var.admin_source_ip
  admin_ssh_public_key = var.admin_ssh_public_key
  tags = {
    Project     = "TaskManager"
    Environment = "Production"
    ManagedBy   = "Terraform"
    Owner       = var.owner_email
    CostCenter  = "DevOps-Portfolio"
  }
}

# Outputs from module
output "vm_public_ip" {
  value = module.infrastructure.vm_public_ip
}

output "ssh_command" {
  value = module.infrastructure.ssh_command
}

output "storage_account_name" {
  value = module.infrastructure.storage_account_name
}
