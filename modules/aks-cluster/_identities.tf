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

