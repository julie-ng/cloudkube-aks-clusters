output "summary" {
  value = {
    env      = var.env
    hostname = var.hostname
    azure_subscription = {
      id        = data.azurerm_client_config.current.subscription_id
      tenant_id = data.azurerm_client_config.current.tenant_id
    }
    resource_group = {
      name     = azurerm_resource_group.cluster_rg.name
      location = azurerm_resource_group.cluster_rg.location
    }
    virtual_network = {
      name           = data.azurerm_virtual_network.cloudkube_vnet.name
      address_space  = data.azurerm_virtual_network.cloudkube_vnet.address_space[0]
      resource_group = data.azurerm_resource_group.networking.name
      static_ingress_ip = {
        name    = data.azurerm_public_ip.aks_ingress.name
        address = data.azurerm_public_ip.aks_ingress.ip_address
      }
      # subnets = data.azurerm_virtual_network.cloudkube_vnet.subnets # doesnt' show address prefixes
      subnets = {
        "${data.azurerm_subnet.aks_api_server.name}" = data.azurerm_subnet.aks_api_server.address_prefixes[0]
        "${data.azurerm_subnet.aks_nodes.name}"      = data.azurerm_subnet.aks_nodes.address_prefixes[0]
      }
    }
    aks_cluster = {
      name             = azurerm_kubernetes_cluster.aks.name
      id               = azurerm_kubernetes_cluster.aks.id
      fqdn             = azurerm_kubernetes_cluster.aks.fqdn
      identity         = azurerm_kubernetes_cluster.aks.identity
      node_rg          = azurerm_kubernetes_cluster.aks.node_resource_group
      kubelet_identity = azurerm_kubernetes_cluster.aks.kubelet_identity
    }
    tls_key_vault = {
      id                  = data.azurerm_key_vault.shared_kv.id
      name                = data.azurerm_key_vault.shared_kv.name
      resource_group_name = data.azurerm_key_vault.shared_kv.resource_group_name
    }
    role_assignments = {
      kubelet_rbac = {
        cluster_kv = {
          scope                = azurerm_role_assignment.cluster_kv_kubelet_mi.scope
          role_definition_name = azurerm_role_assignment.cluster_kv_kubelet_mi.role_definition_name
        }
      }
    }
    managed_identities = {
      control_plane = azurerm_user_assigned_identity.control_plane_mi
      kubelet       = azurerm_user_assigned_identity.kubelet_mi
    }
    key_vault = {
      id                         = azurerm_key_vault.cluster_kv.id
      name                       = azurerm_key_vault.cluster_kv.name
      enable_rbac_authorization  = azurerm_key_vault.cluster_kv.enable_rbac_authorization
      soft_delete_retention_days = azurerm_key_vault.cluster_kv.soft_delete_retention_days
      vault_uri                  = azurerm_key_vault.cluster_kv.vault_uri
      sku_name                   = azurerm_key_vault.cluster_kv.sku_name
    }
  }
}
