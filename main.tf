# Suffix to avoid errors on Azure resources that require globally unique names.
resource "random_string" "suffix" {
  length      = var.suffix_length
  min_lower   = 2
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
  system_vm_size            = var.system_vm_size
  user_vm_size              = var.user_vm_size
  nodes_enable_auto_scaling = var.nodes_enable_auto_scaling
  system_nodes_min_count    = var.system_nodes_min_count
  system_nodes_max_count    = var.system_nodes_max_count
  user_nodes_min_count      = var.user_nodes_min_count
  user_nodes_max_count      = var.user_nodes_max_count
  user_node_count           = var.user_node_count
  automatic_channel_upgrade = var.automatic_channel_upgrade

  # ACR
  azure_container_registry_sku           = var.azure_container_registry_sku
  azure_container_registry_admin_enabled = var.azure_container_registry_admin_enabled

  # Accounts
  node_admin_username        = var.node_admin_username
  node_admin_ssh_public_key  = file(var.node_admin_ssh_public_key)
  node_identity_type         = var.node_identity_type
  aks_disable_local_accounts = var.aks_disable_local_accounts

  # Networking
  # aks_dns_prefix        = var.aks_dns_prefix
  aks_network_plugin    = var.aks_network_plugin
  aks_load_balancer_sku = var.aks_load_balancer_sku

  vnet_address_space          = var.vnet_address_space
  aks_subnet_address_prefixes = var.aks_subnet_address_prefixes

  # Required VNet integration config
  aks_service_cidr       = var.aks_service_cidr
  aks_dns_service_cidr   = var.aks_dns_service_cidr
  aks_docker_bridge_cidr = var.aks_docker_bridge_cidr

  # TLS from shared infra rg
  tls_key_vault = var.tls_key_vault

  # Log Analytics
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_workspace_rg   = var.log_analytics_workspace_rg
}
