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
    name                 = "system" # default pool is always system
    orchestrator_version = var.kubernetes_version
    vm_size              = var.user_vm_size
    vnet_subnet_id       = azurerm_subnet.aks.id
    enable_auto_scaling  = var.nodes_enable_auto_scaling
    min_count            = var.user_nodes_min_count
    max_count            = var.user_nodes_max_count

    upgrade_settings {
      max_surge = 2 # allow 2 extra nodes beyond `max_count` during upgrades
    }
  }

  network_profile {
    network_plugin    = var.aks_network_plugin
    load_balancer_sku = var.aks_load_balancer_sku
    service_cidr      = var.aks_service_cidr
    dns_service_ip    = var.aks_dns_service_cidr
  }

  web_app_routing {
    dns_zone_id = ""
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
      default_node_pool[0].node_count
    ]
  }

  depends_on = [
    azurerm_role_assignment.control_plane_mi,
    azurerm_role_assignment.kubelet_mi_operator
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  mode                  = "User"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  orchestrator_version  = var.kubernetes_version
  os_type               = "Linux"
  os_sku                = "Ubuntu"
  vm_size               = var.system_vm_size
  vnet_subnet_id        = azurerm_subnet.aks.id
  enable_auto_scaling   = true
  min_count             = var.system_nodes_min_count
  max_count             = var.system_nodes_max_count
  # tags                  = var.default_tags

  upgrade_settings {
    max_surge = 2
  }

  lifecycle {
    ignore_changes = [
      tags,
      node_count
    ]
  }
}

# TODO: upgrade node pools via Bicep instead.

# resource "null_resource" "upgrade_user_pools" {
#   triggers = {
#     user_node_pool_version = azurerm_kubernetes_cluster_node_pool.system.orchestrator_version
#   }

#   provisioner "local-exec" {
#     command = "az aks nodepool upgrade --cluster-name $CLUSTER_NAME --name $NODE_POOL_NAME --resource-group $RESOURCE_GROUP_NAME"
#     environment = {
#       CLUSTER_NAME        = azurerm_kubernetes_cluster.aks.name
#       NODE_POOL_NAME      = azurerm_kubernetes_cluster_node_pool.system.name
#       RESOURCE_GROUP_NAME = azurerm_kubernetes_cluster.aks.resource_group_name
#     }
#   }
# }

# resource "null_resource" "upgrade_system_nodes" {
#   triggers = {
#     system_node_pool_version = azurerm_kubernetes_cluster.aks.default_node_pool[0].orchestrator_version
#   }

#   provisioner "local-exec" {
#     command = "az aks nodepool upgrade --cluster-name $CLUSTER_NAME --name $NODE_POOL_NAME --resource-group $RESOURCE_GROUP_NAME"
#     environment = {
#       CLUSTER_NAME        = azurerm_kubernetes_cluster.aks.name
#       NODE_POOL_NAME      = azurerm_kubernetes_cluster.aks.default_node_pool[0].name # "system"
#       RESOURCE_GROUP_NAME = azurerm_kubernetes_cluster.aks.resource_group_name
#     }
#   }
# }

# Data Sources
# ------------

# Log Analytics Workspace
data "azurerm_log_analytics_workspace" "cloudkube" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_rg
}
