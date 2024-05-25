terraform {
  backend "azurerm" {} # see environments/backend.hcl.sample

  required_providers {
    azurerm = {
      version = ">= 3.88.0"
      source  = "hashicorp/azurerm"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30.0"
    }
  }
}

provider "azurerm" {
  storage_use_azuread = true
  features {}
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
