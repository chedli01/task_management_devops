resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-${var.environment}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "taskmanager-dns"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}