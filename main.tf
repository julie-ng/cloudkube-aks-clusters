# =======
#  Setup
# =======

terraform {
  backend "azurerm" {} # see environments/backend.hcl.sample
}

# Suffix to avoid errors on Azure resources that require globally unique names.
resource "random_string" "suffix" {
  length      = 4
  min_lower   = 3
  min_numeric = 1
  special     = false
  upper       = false
  number      = true
}

locals {
  suffix = var.suffix == "" ? random_string.suffix.result : var.suffix
}

# =============
#  AKS Cluster
# =============

module "cluster" {
  source   = "./modules/aks-cluster"
  suffix   = local.suffix
  name     = var.name
  env      = var.env
  hostname = var.hostname
  location = var.location

  default_tags = {
    env    = "dev"
    iac    = "terraform"
    demo   = "true"
    public = "true"
  }

  # AKS Config
  kubernetes_version        = var.kubernetes_version
  vm_size                   = var.vm_size
  nodes_enable_auto_scaling = var.nodes_enable_auto_scaling
  nodes_min_count           = var.nodes_min_count
  nodes_max_count           = var.nodes_max_count

  # ACR
  azure_container_registry_sku           = var.azure_container_registry_sku
  azure_container_registry_admin_enabled = var.azure_container_registry_admin_enabled

  # Accounts
  node_admin_username       = var.node_admin_username
  node_admin_ssh_public_key = file(var.node_admin_ssh_public_key)
  node_identity_type        = var.node_identity_type

  # Networking
  # aks_dns_prefix        = var.aks_dns_prefix
  aks_network_plugin    = var.aks_network_plugin
  aks_load_balancer_sku = var.aks_load_balancer_sku

  vnet_address_space          = var.vnet_address_space
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes

  # Required VNet integration config
  aks_service_cidr            = var.aks_service_cidr
  aks_dns_service_cidr        = var.aks_dns_service_cidr
  aks_docker_bridge_cidr      = var.aks_docker_bridge_cidr

  # TLS from shared infra rg
  tls_key_vault = var.tls_key_vault
}

# =========
#  Outputs
# =========

output "summary" {
  value = module.cluster.summary
}
