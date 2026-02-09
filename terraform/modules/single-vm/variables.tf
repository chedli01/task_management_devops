variable "project_name" {
    type = string
    description = "Project name used for resource naming"
    default = "task-manager" 
}
variable "environment" {
    type = string
    description = "Environment name (dev, staging, prod)"
    default = "prod"
}
variable "location" {
    type = string
    description = "Azure region"
    default = "switzerlandnorth"
}
variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_D2s_v3"
}
variable "admin_username" {
    type = string
    description = "Admin username for VM"
    default = "azureuser"
}
variable "admin_source_ip" {
    type = string
    description = "IP address for SSH access (format: x.x.x.x/32)"
}
variable "admin_ssh_public_key" {
    type = string
    description = "SSH public key for VM access"
}
variable "tags"{
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "TaskManager"
    ManagedBy   = "Terraform"
    Environment = "Production"
  }
}
