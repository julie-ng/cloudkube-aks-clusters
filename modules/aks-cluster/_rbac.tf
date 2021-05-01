# ==================
#  Role Assignments
# ==================

# AAD Pod Identity
# ----------------

resource "azurerm_role_assignment" "kubelet_mi_operator_nodes" {
  role_definition_name = "Managed Identity Operator"
  scope                = data.azurerm_resource_group.aks_managed.id
  principal_id         = data.azurerm_user_assigned_identity.kubelet.principal_id
}

resource "azurerm_role_assignment" "kubelet_vm_contributor" {
  role_definition_name = "Virtual Machine Contributor"
  scope                = data.azurerm_resource_group.aks_managed.id
  principal_id         = data.azurerm_user_assigned_identity.kubelet.principal_id
}

# Static IP for LB
# ----------------

resource "azurerm_role_assignment" "aks_mi_network_contributor" {
  role_definition_name = "Network Contributor"
  scope                = azurerm_resource_group.cluster_rg.id
  principal_id         = azurerm_user_assigned_identity.aks_mi.principal_id
}

# ACR
# ---

resource "azurerm_role_assignment" "acr_assignments" {
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.acr.id
  principal_id         = data.azurerm_user_assigned_identity.kubelet.principal_id
}

# Key Vault
# ---------

resource "azurerm_role_assignment" "kv_admin" {
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
  scope                = azurerm_key_vault.cluster_kv.id
}

resource "azurerm_role_assignment" "cluster_kv_ingress_mi" {
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.ingress_pod.principal_id
  scope                = azurerm_key_vault.cluster_kv.id
}
