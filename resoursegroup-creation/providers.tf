terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.50" # Use latest stable version
    }
  }
}

provider "azurerm" {
  features {}
}
