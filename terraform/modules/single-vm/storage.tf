# Storage Account for backups and logs
resource "azurerm_storage_account" "main" {
  name                     = "${var.project_name}${var.environment}${random_string.storage.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # Locally Redundant Storage (cheapest)
  
  # Security settings
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  
  tags = merge(
    var.tags,
    {
      Component = "Storage"
    }
  )
}

# Container for database backups
resource "azurerm_storage_container" "backups" {
  name                  = "database-backups"
  storage_account_name = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Container for application logs
resource "azurerm_storage_container" "logs" {
  name                  = "application-logs"
  storage_account_name = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Container for Terraform state (optional, for remote backend)
resource "azurerm_storage_container" "terraform_state" {
  name                  = "terraform-state"
  storage_account_name = azurerm_storage_account.main.name
  container_access_type = "private"
}