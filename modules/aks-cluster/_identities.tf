# ===================
#  Cluster Identiies
# ===================

# Control Plane
resource "azurerm_user_assigned_identity" "control_plane_mi" {
  name                = "${local.name_suffixed}-control-plane-mi"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  location            = azurerm_resource_group.cluster_rg.location
}

# Kubelet
resource "azurerm_user_assigned_identity" "kubelet_mi" {
  name                = "${local.name_suffixed}-kubelet-mi"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  location            = azurerm_resource_group.cluster_rg.location
}

# ingress workload
resource "azurerm_user_assigned_identity" "ingress_workload_mi" {
  name                = "${local.name_suffixed}-ingress-mi"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  location            = azurerm_resource_group.cluster_rg.location
}

# ingress workload
resource "azurerm_federated_identity_credential" "ingress_workload_mi" {
  name                = "${local.name_suffixed}-ingress-federated-credential"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.ingress_workload_mi.id
  subject             = "system:serviceaccount:ingress:ingress-workload-identity" # hard code for now. Move to sep. TF module later
}

resource "azurerm_federated_identity_credential" "aks_cheatsheets_ingress_to_kv" {
  name                = "${local.name_suffixed}-aks-cheatsheets-federated-credential"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.ingress_workload_mi.id
  subject             = "system:serviceaccount:aks-cheatsheets:ingress-workload-identity" # hard code for now. Move to sep. TF module later
}

resource "azurerm_federated_identity_credential" "hello_world_ingress_to_kv" {
  name                = "${local.name_suffixed}-hello-world-federated-credential"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.ingress_workload_mi.id
  subject             = "system:serviceaccount:hello-world:ingress-workload-identity" # hard code for now. Move to sep. TF module later
}
