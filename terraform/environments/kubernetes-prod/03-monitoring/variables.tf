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
