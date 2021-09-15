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

  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    vnet_subnet_id      = azurerm_subnet.aks.id
    enable_auto_scaling = var.nodes_enable_auto_scaling
    min_count           = var.nodes_min_count
    max_count           = var.nodes_max_count
  }

  network_profile {
    network_plugin     = var.aks_network_plugin
    load_balancer_sku  = var.aks_load_balancer_sku
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = var.aks_dns_service_cidr
    docker_bridge_cidr = var.aks_docker_bridge_cidr
  }

  # Control Plane
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_mi.id
  }

  linux_profile {
    admin_username = var.node_admin_username

    ssh_key {
      key_data = var.node_admin_ssh_public_key
    }
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }

    # oms_agent {
    #   enabled = true
    #   log_analytics_workspace_id = azurerm_log_analytics_workspace.cluster.id
    # }
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed            = true
      azure_rbac_enabled = true
    }
  }
}


# AKS Nodes RG
# ------------

data "azurerm_resource_group" "aks_managed" {
  name = "${local.name_suffixed}-managed-rg"
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}
