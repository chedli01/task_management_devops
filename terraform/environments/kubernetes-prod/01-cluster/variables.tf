variable "project_name" {
    type = string
    description = "Project name used for resource naming"
    default = "task-manager" 
}
variable "environment" {
    type = string
    description = "Environment name (dev, staging, prod)"
    default = "prod-k8s"
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
variable "node_count" {
  type = number
  description = "Number of nodes in the default node pool"
  default = 2
}
variable "tags"{
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "TaskManager"
    ManagedBy   = "Terraform"
    Environment = "Production-k8s"
  }
}
