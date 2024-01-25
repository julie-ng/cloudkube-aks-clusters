# Virtual Network
# ---------------

resource "azurerm_virtual_network" "cluster_vnet" {
  name                = "${local.name}-vnet"
  location            = azurerm_resource_group.cluster_rg.location
  resource_group_name = azurerm_resource_group.cluster_rg.name
  address_space       = var.vnet_address_space
  tags                = var.default_tags
}

# AKS Subnet
# ----------

resource "azurerm_subnet" "aks" {
  name                 = "aks-nodes-subnet"
  resource_group_name  = azurerm_resource_group.cluster_rg.name
  virtual_network_name = azurerm_virtual_network.cluster_vnet.name
  address_prefixes     = var.aks_subnet_address_prefixes
}

# Static IP for LB
# ----------------

resource "azurerm_public_ip" "ingress" {
  name                = "${local.name}-ingress-ip"
  resource_group_name = azurerm_resource_group.cluster_rg.name
  location            = azurerm_resource_group.cluster_rg.location
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = var.default_tags

  depends_on = [
    azurerm_kubernetes_cluster.aks
  ]

  # Used in DNS records (managed by another IaC repo)
  # lifecycle {
  #   prevent_destroy = true
  # }
}
