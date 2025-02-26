
###########--- Creating the vnetwork#########

resource "azurerm_virtual_network" "myvnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

###########--- Creating the frontend subnetwork-----#########
resource "azurerm_subnet" "frontendsubnet" {
  name                 = "frontendSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

### VM 1: Public IP & NIC ###which is attached to vm
resource "azurerm_public_ip" "myvm1publicip" {
  name                = "pip1"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "myvm1nic" {
  name                = "myvm1-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.frontendsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myvm1publicip.id
  }
}


### VM 2: Public IP & NIC ###
resource "azurerm_public_ip" "myvm2publicip" {
  name                = "pip2"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "myvm2nic" {
  name                = "myvm2-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.frontendsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myvm2publicip.id
  }
}

### VM 1: Standard_B1s ###
resource "azurerm_linux_virtual_machine" "myvm1" {
  name                  = "myvm1"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.myvm1nic.id]
  size                  = var.vm1_size
  admin_username        = "sasender"

  disable_password_authentication = false
  admin_password                  = "Sasender@96"  # Change this to a secure password

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

### VM 2: Standard_D2s_v3 ###
resource "azurerm_linux_virtual_machine" "myvm2" {
  name                  = "myvm2"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.myvm2nic.id]
  size                  = var.vm2_size
  admin_username        = "sasender"

  disable_password_authentication = false
  admin_password                  = "Sasender@96"  # Change this to a secure password

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
