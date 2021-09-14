terraform {
  backend "azurerm" {} # see environments/backend.hcl.sample

  required_providers {
    azurerm = {
      version = ">= 2.76.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}
