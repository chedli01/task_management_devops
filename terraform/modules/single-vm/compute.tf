# Cloud-init configuration for VM setup
data "cloudinit_config" "vm_init" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init.yml", {
      admin_username = var.admin_username
    })
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.project_name}-${var.environment}-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.vm_size
  admin_username      = var.admin_username
  
  # Managed Identity
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm.id]
  }
  
  # Network Interface
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]
  
  # SSH Authentication (no password!)
  disable_password_authentication = true
  
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_public_key
  }
  
  # OS Disk
  os_disk {
    name                 = "${var.project_name}-${var.environment}-vm-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }
  
  # Ubuntu 24.04 LTS
  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
  
  # Cloud-init for initial setup
  custom_data = data.cloudinit_config.vm_init.rendered
  
  # Boot diagnostics
  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.main.primary_blob_endpoint
  }
  
  tags = merge(
    var.tags,
    {
      Component = "Compute"
      Role      = "Application"
    }
  )
}