
resource "azurerm_resource_group" "vinted_rg" {
  name     = var.vinted_rg_name
  location = var.vinted_rg_location
}

resource "azurerm_virtual_network" "vinted_vnet" {
  name                = var.vinted_vnet_name
  address_space       = var.vinted_vnet_address_space
  location            = azurerm_resource_group.vinted_rg.location
  resource_group_name = azurerm_resource_group.vinted_rg.name
  tags                = var.vinted_tags
}

resource "azurerm_subnet" "vinted_subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.vinted_rg.name
  virtual_network_name = azurerm_virtual_network.vinted_vnet.name
  address_prefixes     = var.vinted_subnet_address_space
}

resource "azurerm_public_ip" "vinted_public_ip" {
  name                = var.vinted_public_ip_name
  resource_group_name = azurerm_resource_group.vinted_rg.name
  location            = azurerm_resource_group.vinted_rg.location
  allocation_method   = "Static"
  tags                = var.vinted_tags
}

resource "azurerm_network_interface" "vinted_nic" {
  name                = var.vinted_nic_name
  location            = azurerm_resource_group.vinted_rg.location
  resource_group_name = azurerm_resource_group.vinted_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vinted_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vinted_public_ip.id
  }

  tags = var.vinted_tags
}

resource "azurerm_network_security_group" "vinted_nsg" {
  name                = var.vinted_nsg_name
  location            = azurerm_resource_group.vinted_rg.location
  resource_group_name = azurerm_resource_group.vinted_rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_3000"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.vinted_tags
}

resource "azurerm_network_interface_security_group_association" "vinted_nic_sg_association" {
  network_interface_id      = azurerm_network_interface.vinted_nic.id
  network_security_group_id = azurerm_network_security_group.vinted_nsg.id
}

resource "azurerm_linux_virtual_machine" "vinted_oicd_app_vm" {
  name                = var.vinted_oicd_app_vm_name
  resource_group_name = azurerm_resource_group.vinted_rg.name
  location            = azurerm_resource_group.vinted_rg.location
  size                = var.vinted_oicd_app_vm_size
  admin_username      = var.vinted_oicd_app_vm_admin_username

  network_interface_ids = [
    azurerm_network_interface.vinted_nic.id,
  ]

  admin_ssh_key {
    username   = var.vinted_oicd_app_vm_admin_username
    public_key = file(var.vinted_oicd_app_vm_admin_public_key_path)
  }

  os_disk {
    caching              = var.vinted_oicd_app_vm_os_disk_caching
    storage_account_type = var.vinted_oicd_app_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.vinted_oicd_app_vm_image_publisher
    offer     = var.vinted_oicd_app_vm_image_offer
    sku       = var.vinted_oicd_app_vm_image_sku
    version   = var.vinted_oicd_app_vm_image_version
  }
  tags = var.vinted_tags
}

resource "azurerm_container_registry" "vinted_acr" {
  name                = var.vinted_container_registry_name
  resource_group_name = azurerm_resource_group.vinted_rg.name
  location            = azurerm_resource_group.vinted_rg.location
  sku                 = "Premium"
  admin_enabled       = false
}