terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.47"
    }
  }
}
provider "azurerm" {
  features {}
}