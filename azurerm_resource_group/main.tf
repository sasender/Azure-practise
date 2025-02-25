# provider "azurerm" {
#   features {}
# }

resource "azurerm_resource_group" "rg" {
  name     = "my-first-terraform-rg"
  location = "northeurope"
}

resource "azurerm_virtual_network" "myvnet" {
  name                = "my-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "frontendsubnet" {
  name                 = "frontendSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "myvm1publicip" {
  name                = "pip1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "myvm1nic" {
  name                = "myvm1-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.frontendsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myvm1publicip.id
  }
}

resource "azurerm_linux_virtual_machine" "myvm1" {
  name                  = "myvm1"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.myvm1nic.id]
  size                  = "Standard_B1s"
  admin_username        = "sasender"

  # Using Password for Authentication
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

########azure-storage-creation

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate-sasender"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  # public_network_access    = "Disabled"
  # enable_https_traffic_only = true
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id   = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}

# resource "random_string" "suffix" {
#   length  = 6
#   special = false
#   upper   = false
# }
