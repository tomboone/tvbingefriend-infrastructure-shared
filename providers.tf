terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.42"
    }
  }
}
provider "azurerm" {
  features {}
}