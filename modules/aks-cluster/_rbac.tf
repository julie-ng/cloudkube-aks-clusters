# ==================
#  Role Assignments
# ==================

# Try to prevent Terraform from constantly re-creating Role Assignments

# https://github.com/hashicorp/terraform-provider-azurerm/issues/15557
# https://github.com/hashicorp/terraform-provider-azurerm/issues/13152
#
# See also doc on whow data sources are handled and thus this behavior…
# becaues the IDs are upstream.
# https://www.terraform.io/language/data-sources#data-resource-dependencies

locals {
  cluster_principal_id       = azurerm_user_assigned_identity.control_plane_mi.principal_id
  kubelet_principal_id       = azurerm_user_assigned_identity.kubelet_mi.principal_id
  aks_managed_resource_group = azurerm_kubernetes_cluster.aks.node_resource_group
  # Don't cobble together id just to use a system managed identity
  # aks_managed_resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.name_suffixed}-managed-rg" # circular dependency
}

data "azurerm_resource_group" "aks_managed" {
  name = local.aks_managed_resource_group

  # needed if manaul suffix
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}


# Give Self Admin Access
# ----------------------

resource "azurerm_role_assignment" "admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = azurerm_kubernetes_cluster.aks.id
  principal_id         = data.azurerm_client_config.current.object_id # Me
}


# Managed Identity
# ----------------

# Our Resource Group

resource "azurerm_role_assignment" "control_plane_mi" {
  role_definition_name = "Managed Identity Operator"
  scope                = azurerm_resource_group.cluster_rg.id
  principal_id         = azurerm_user_assigned_identity.control_plane_mi.principal_id
}

resource "azurerm_role_assignment" "kubelet_mi_operator" {
  role_definition_name = "Managed Identity Operator"
  scope                = azurerm_resource_group.cluster_rg.id
  principal_id         = azurerm_user_assigned_identity.kubelet_mi.principal_id
}

# AKS Managed Resource Group

resource "azurerm_role_assignment" "control_plane_mi_nodes" {
  role_definition_name = "Managed Identity Operator"
  scope                = data.azurerm_resource_group.aks_managed.id
  principal_id         = azurerm_user_assigned_identity.control_plane_mi.principal_id

  # circular - wait for managed RG
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

resource "azurerm_role_assignment" "kubelet_mi_operator_nodes" {
  role_definition_name = "Managed Identity Operator"
  scope                = data.azurerm_resource_group.aks_managed.id
  principal_id         = azurerm_user_assigned_identity.kubelet_mi.principal_id

  # circular - wait for managed RG
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}


# VMs
# ---

resource "azurerm_role_assignment" "kubelet_vm_contributor" {
  role_definition_name = "Virtual Machine Contributor"
  scope                = data.azurerm_resource_group.aks_managed.id
  principal_id         = azurerm_user_assigned_identity.kubelet_mi.principal_id
}


# Static IP for LB
# ----------------

resource "azurerm_role_assignment" "aks_mi_network_contributor" {
  role_definition_name = "Network Contributor"
  scope                = azurerm_resource_group.cluster_rg.id
  principal_id         = azurerm_user_assigned_identity.control_plane_mi.principal_id
}


# Key Vault
# ---------

resource "azurerm_role_assignment" "kv_admin" {
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.cluster_kv.id
  principal_id         = data.azurerm_client_config.current.object_id # Me
}

resource "azurerm_role_assignment" "cluster_kv_kubelet_mi" {
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.cluster_kv.id
  principal_id         = azurerm_user_assigned_identity.kubelet_mi.principal_id
}
