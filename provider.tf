terraform {
  backend "azurerm" {} # see environments/backend.hcl.sample

  required_providers {
    azurerm = {
      version = ">= 3.0.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}
