# ===================
#  Cluster Identiies
# ===================

# AKS

resource "azurerm_user_assigned_identity" "aks_mi" { # Control Plane
  name                = "${local.name}-mi"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  location            = azurerm_resource_group.cluster_rg.location
}

# Kubelet MI

data "azurerm_user_assigned_identity" "kubelet" {
  name                = "${local.name_suffixed}-cluster-agentpool"
  resource_group_name = "${local.name_suffixed}-managed-rg"
  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]
}

# Ingress Pod (nodes rg)

resource "azurerm_user_assigned_identity" "ingress_pod" {
  name                = "${local.name}-ingress-pod-mi"
  location            = data.azurerm_resource_group.aks_managed.location
  resource_group_name = data.azurerm_resource_group.aks_managed.name
}