# =============
#  AKS Cluster
# =============

resource "azurerm_kubernetes_cluster" "aks" {
  kubernetes_version  = var.kubernetes_version
  name                = "${local.name_suffixed}-cluster"
  location            = azurerm_resource_group.cluster_rg.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  node_resource_group = "${local.name_suffixed}-managed-rg"
  dns_prefix          = local.aks_dns_prefix
  tags                = var.default_tags

  local_account_disabled            = var.aks_disable_local_accounts
  role_based_access_control_enabled = true
  automatic_channel_upgrade         = var.automatic_channel_upgrade
  azure_policy_enabled              = true

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.control_plane_mi.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet_mi.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet_mi.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet_mi.id
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name                 = var.system_node_pool_name # default pool is always system
    os_sku               = var.os_sku
    orchestrator_version = var.kubernetes_version
    vm_size              = var.system_vm_size
    vnet_subnet_id       = data.azurerm_subnet.aks_nodes.id
    enable_auto_scaling  = var.nodes_enable_auto_scaling
    min_count            = var.system_nodes_min_count
    max_count            = var.system_nodes_max_count
    tags                 = var.default_tags

    upgrade_settings {
      max_surge = 2 # allow 2 extra nodes beyond `max_count` during upgrades
    }
  }

  api_server_access_profile {
    vnet_integration_enabled = true
    subnet_id                = data.azurerm_subnet.aks_api_server.id
  }

  network_profile {
    network_plugin    = var.aks_network_plugin
    load_balancer_sku = var.aks_load_balancer_sku
    service_cidr      = local.k8s_service_cidr
    dns_service_ip    = local.k8s_dns_service_ip
  }

  linux_profile {
    admin_username = var.node_admin_username

    ssh_key {
      key_data = var.node_admin_ssh_public_key
    }
  }

  microsoft_defender {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.cloudkube.id
  }

  oms_agent {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.cloudkube.id
  }

  lifecycle {
    ignore_changes = [
      tags,
      # kubernetes_version,
      default_node_pool[0].node_count,
      default_node_pool[0].orchestrator_version
    ]
  }

  depends_on = [
    azurerm_role_assignment.control_plane_mi,
    azurerm_role_assignment.kubelet_mi_operator,
    azurerm_role_assignment.control_plane_on_api_server_subnet,
    azurerm_role_assignment.control_plane_on_nodes_subnet
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = var.user_node_pool_name
  mode                  = "User"
  os_sku                = var.os_sku
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  orchestrator_version  = var.kubernetes_version
  vm_size               = var.user_vm_size
  vnet_subnet_id        = data.azurerm_subnet.aks_nodes.id
  enable_auto_scaling   = true
  min_count             = var.user_nodes_min_count
  max_count             = var.user_nodes_max_count
  tags                  = var.default_tags

  upgrade_settings {
    max_surge = 2
  }

  lifecycle {
    ignore_changes = [
      tags,
      node_count,
      orchestrator_version
    ]
  }
}

# Data Sources
# ------------

# Log Analytics Workspace
data "azurerm_log_analytics_workspace" "cloudkube" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_rg
}
