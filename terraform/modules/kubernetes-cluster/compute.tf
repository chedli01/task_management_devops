resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.project_name}-${var.environment}-cluster"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "taskmanager-dns"

  oidc_issuer_enabled = true

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    vnet_subnet_id = azurerm_subnet.app.id
  }

  identity {
    type = "SystemAssigned"
  }
  network_profile {
    network_plugin    = "azure" 
    load_balancer_sku = "standard"
    service_cidr      = "172.16.0.0/16"      
    dns_service_ip    = "172.16.0.10"     
  }
}