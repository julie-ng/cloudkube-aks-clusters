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


  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_mi.id]
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  default_node_pool {
    name                 = "system"
    orchestrator_version = var.kubernetes_version
    vm_size              = var.system_vm_size
    vnet_subnet_id       = azurerm_subnet.aks.id
    enable_auto_scaling  = var.nodes_enable_auto_scaling
    min_count            = var.system_nodes_min_count
    max_count            = var.system_nodes_max_count
    node_labels = {
      workloadType = "system"
    }

    upgrade_settings {
      max_surge = 1 # allow 2 extra nodes beyond `max_count` during upgrades
    }
  }

  network_profile {
    network_plugin     = var.aks_network_plugin
    load_balancer_sku  = var.aks_load_balancer_sku
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = var.aks_dns_service_cidr
    docker_bridge_cidr = var.aks_docker_bridge_cidr
  }

  linux_profile {
    admin_username = var.node_admin_username

    ssh_key {
      key_data = var.node_admin_ssh_public_key
    }
  }

  oms_agent {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.cloudkube.id
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  orchestrator_version  = var.kubernetes_version
  os_type               = "Linux"
  os_sku                = "Ubuntu"
  vm_size               = var.user_vm_size
  vnet_subnet_id        = azurerm_subnet.aks.id
  enable_auto_scaling   = true
  min_count             = var.user_nodes_min_count
  max_count             = var.user_nodes_max_count
  tags                  = var.default_tags

  node_labels = {
    workloadType = "user"
  }

  upgrade_settings {
    max_surge = 1
  }

  lifecycle {
    ignore_changes = [
      tags
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

# AKS Nodes RG
data "azurerm_resource_group" "aks_managed" {
  name = "${local.name_suffixed}-managed-rg"
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
