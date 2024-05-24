terraform {
  backend "azurerm" {} # see environments/backend.hcl.sample

  required_providers {
    azurerm = {
      version = ">= 3.88.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  storage_use_azuread = true
  features {}
}
