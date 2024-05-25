# Suffix to avoid errors on Azure resources that require globally unique names.
resource "random_string" "suffix" {
  length      = var.suffix_length
  min_lower   = 2
  min_numeric = 1
  special     = false
  upper       = false
  numeric     = true
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
  nodes_enable_auto_scaling = var.nodes_enable_auto_scaling
  automatic_channel_upgrade = var.automatic_channel_upgrade

  # system node pool
  system_node_pool_name  = var.system_node_pool_name
  system_vm_size         = var.system_vm_size
  system_nodes_min_count = var.system_nodes_min_count
  system_nodes_max_count = var.system_nodes_max_count

  # user node pool
  user_node_pool_name  = var.user_node_pool_name
  user_vm_size         = var.user_vm_size
  user_nodes_min_count = var.user_nodes_min_count
  user_nodes_max_count = var.user_nodes_max_count
  user_node_count      = var.user_node_count

  # Accounts
  node_admin_username        = var.node_admin_username
  node_admin_ssh_public_key  = file(var.node_admin_ssh_public_key)
  node_identity_type         = var.node_identity_type
  aks_disable_local_accounts = var.aks_disable_local_accounts

  # Networking
  aks_network_plugin    = var.aks_network_plugin
  aks_load_balancer_sku = var.aks_load_balancer_sku

  # TLS from shared infra rg
  tls_key_vault = var.tls_key_vault

  # Log Analytics
  log_analytics_workspace_name = var.log_analytics_workspace_name
  log_analytics_workspace_rg   = var.log_analytics_workspace_rg
}

locals {
  # workloads = {
  #   hello_world = {
  #     name        = "hello-world"
  #     description = "The hello-welt app used on dev.cloudkube.io"
  #   }
  #   aks_cheatsheets = {
  #     name        = "aks-cheatsheets"
  #     description = "aks-cheatsheets.dev app"
  #   }
  # }
  workloads = ["hello-world", "aks-cheatsheets"]
}

module "workloads" {
  for_each = toset(local.workloads)
  source   = "./modules/workload"

  name                = each.value
  suffix              = local.suffix
  resource_group_name = module.cluster.summary.resource_group.name
  aks_oidc_issuer_url = module.cluster.summary.aks_cluster.oidc_issuer_url
}
