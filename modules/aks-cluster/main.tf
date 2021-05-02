# ================
#  Resource Group
# ================

resource "azurerm_resource_group" "cluster_rg" {
  name     = "${local.name_suffixed}-rg"
  location = var.location
  tags     = var.default_tags
}

# ================
#  Normalizd Vars
# ================

locals {
  name           = lower(var.name)
  name_suffixed  = lower("${var.name}%{if var.suffix != ""}-${var.suffix}%{endif}")
  name_squished  = replace(local.name_suffixed, "-", "")
  aks_dns_prefix = var.aks_dns_prefix == "" ? var.name : var.aks_dns_prefix
}

# ===============
#  Client Config
# ===============

data "azurerm_client_config" "current" {}
