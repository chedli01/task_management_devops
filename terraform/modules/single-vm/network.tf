resource "azurerm_virtual_network" "main" {
    name = "${var.project_name}-${var.environment}-vnet"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
    address_space = ["10.0.0.0/16"]
    tags = merge(
    var.tags,
    {
      Component = "Networking"
    }
  )
}


resource "azurerm_subnet" "app" {
    name = "${var.project_name}-${var.environment}-app-subnet"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = ["10.0.1.0/24"] 
}


resource "azurerm_subnet" "data" {
    name = "${var.project_name}-${var.environment}-data-subnet"
    resource_group_name = azurerm_resource_group.main.name
    virtual_network_name = azurerm_virtual_network.main.name
    address_prefixes = ["10.0.2.0/24"]
    service_endpoints = [ "Microsoft.Sql","Microsoft.Storage" ]
}


resource "azurerm_network_security_group" "app" {
    name = "${var.project_name}-${var.environment}-app-nsg"
    location = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name

    tags = merge(
    var.tags,
    {
      Component = "Security"
    }
  )  
}


resource "azurerm_network_security_rule" "allow_http" {
  name                        = "AllowHTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}


resource "azurerm_network_security_rule" "allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}


resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "AllowSSH"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = var.admin_source_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}


resource "azurerm_network_security_rule" "deny_all_inbound" {
  name                        = "DenyAllInbound"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.app.name
}


resource "azurerm_subnet_network_security_group_association" "app" {
    subnet_id = azurerm_subnet.app.id
    network_security_group_id = azurerm_network_security_group.app.id
}


resource "azurerm_public_ip" "vm" {
  name                = "${var.project_name}-${var.environment}-vm-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = merge(
    var.tags,
    {
      Component = "Networking"
    }
  )
}


resource "azurerm_network_interface" "vm" {
  name                = "${var.project_name}-${var.environment}-vm-nic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }

  tags = merge(
    var.tags,
    {
      Component = "Networking"
    }
  )
}