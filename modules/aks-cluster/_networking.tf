# Virtual Network
# See https://github.com/julie-ng/cloudkube-networking-iac

data "azurerm_resource_group" "networking" {
  name = "${var.name}-networking-rg"
}

data "azurerm_virtual_network" "cloudkube_vnet" {
  name                = "${var.name}-vnet"
  resource_group_name = data.azurerm_resource_group.networking.name
}

data "azurerm_subnet" "aks_nodes" {
  name                 = "aks-nodes-subnet"
  virtual_network_name = "${var.name}-vnet"
  resource_group_name  = data.azurerm_resource_group.networking.name
}

data "azurerm_subnet" "aks_api_server" {
  name                 = "aks-api-server-subnet"
  virtual_network_name = "${var.name}-vnet"
  resource_group_name  = data.azurerm_resource_group.networking.name
}

data "azurerm_public_ip" "aks_ingress" {
  name                = "${var.name}-aks-ingress-ip"
  resource_group_name = data.azurerm_resource_group.networking.name
}

locals {
  k8s_service_cidr   = data.azurerm_virtual_network.cloudkube_vnet.tags["reserved-k8s-service-range"]
  k8s_dns_service_ip = data.azurerm_virtual_network.cloudkube_vnet.tags["reserved-k8s-dns-service-ip"]
}
