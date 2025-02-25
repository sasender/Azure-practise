resource "azurerm_resource_group" "rg" {
  name     = "my-first-terraform-rg"
  location = "northeurope"
}

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