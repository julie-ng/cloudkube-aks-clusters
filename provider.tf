terraform {
  backend "azurerm" {} # see environments/backend.hcl.sample
}

provider "azurerm" {
  features {}
}
