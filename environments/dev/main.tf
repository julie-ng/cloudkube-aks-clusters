# DEV Cluster
# -----------

module "cluster" {
  source   = "./../../modules/aks-cluster"
  name     = var.name
  suffix   = var.suffix
  env      = "dev"
  hostname = "dev.cloudkube.io"
  location = "northeurope"

  default_tags = {
    env    = "dev"
    iac    = "terraform"
    demo   = "true"
    public = "true"
  }

  # AKS Config
  kubernetes_version        = "1.19.7"
  vm_size                   = "Standard_DS2_v2"
  nodes_enable_auto_scaling = true
  nodes_min_count           = 1
  nodes_max_count           = 2

  # ACR
  azure_container_registry_sku           = "Basic"
  azure_container_registry_admin_enabled = false

  # Accounts
  node_admin_username       = "ubuntu"
  node_admin_ssh_public_key = file("~/.ssh/id_rsa.pub")
  node_identity_type        = "SystemAssigned"

  # Networking
  aks_dns_prefix        = var.name
  aks_network_plugin    = "azure"
  aks_load_balancer_sku = "Standard"

  vnet_address_space          = ["10.0.0.0/16"]
  aks_subnet_address_prefixes = ["10.0.2.0/24"]

  # Required VNet integration config
  aks_service_cidr            = "10.0.1.0/24"
  aks_dns_service_cidr        = "10.0.1.10"
  aks_docker_bridge_cidr      = "170.10.0.1/16"

  # TLS from shared infra rg
  tls_key_vault = {
    name           = "cloudkube-dev-kv"
    resource_group = "cloudkube-shared-rg"
  }
}

# Outputs
# -------

output "summary" {
  value = module.cluster.summary
}
