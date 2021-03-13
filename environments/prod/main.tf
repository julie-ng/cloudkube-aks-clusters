# In development phase for AKS cluster, this does _NOTHING_.
# We'll create 2nd cluster when we know this works.

locals {
  base_name = lower(var.name)
}

resource "azurerm_resource_group" "cluster" {
  name     = "${local.base_name}-rg"
  location = "Central US"
  tags = {
    env    = "prod"
    demo   = "true"
    public = "true"
  }
}

output "summary" {
  value = {
    note                = "In Dev phase, prod cluster module does nothing, except create a resource group."
    resource_group_name = azurerm_resource_group.cluster.name
  }
}

# Provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.50.0"
    }
  }
}

# Configure the Microsoft Azure Provider

provider "azurerm" {
  features {}
}
