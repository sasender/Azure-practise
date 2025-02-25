terraform {
  backend "azurerm" {
    resource_group_name  = "my-first-terraform-rg"
    storage_account_name = "tfstatesasender"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}