resource "azurerm_virtual_network" "myVnet" {
  name = "myVnet"
  address_space = ["10.2.20.0/22"]
  location = "eastus"
  resource_group_name = "private-rg"
}

resource "azurerm_subnet" "my-subnet" {
  name = "my-subnet"
  address_prefixes = ["10.2.21.0/25"]
  resource_group_name = "private-rg"
  virtual_network_name = azurerm_virtual_network.myVnet.name
}

resource "azurerm_public_ip" "public_ips" {
  count = var.vm_count
  name                = "public-ip-${count.index}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  

  ip_configuration {
    name                          = "config-${count.index}"
    subnet_id                     = azurerm_subnet.my-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.public_ips.*.id,count.index)
  }

}

resource "azurerm_linux_virtual_machine" "vm" {
  count                = var.vm_count
  name                 = "vm-${count.index}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  size                 = var.vm_size
  admin_username       = var.username
  admin_password       = var.password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
  location            = var.location
  resource_group_name = var.resource_group_name
  
  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix = "*"
    destination_address_prefix = "*"
  }
}

output "vm_ips" {
    value = azurerm_public_ip.public_ips[*].ip_address
}

