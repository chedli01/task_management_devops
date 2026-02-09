# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location
  tags     = var.tags
}

# Random string for unique storage account name
resource "random_string" "storage" {
  length  = 8
  special = false
  upper   = false
}