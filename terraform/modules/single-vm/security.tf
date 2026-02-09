# User Assigned Managed Identity for VM
resource "azurerm_user_assigned_identity" "vm" {
  name                = "${var.project_name}-${var.environment}-vm-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
  tags = merge(
    var.tags,
    {
      Component = "Security"
    }
  )
}

# Role Assignment: VM can write to storage account
resource "azurerm_role_assignment" "vm_storage_contributor" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.vm.principal_id
}

# Role Assignment: VM can read its own resource group (for monitoring)
resource "azurerm_role_assignment" "vm_reader" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.vm.principal_id
}