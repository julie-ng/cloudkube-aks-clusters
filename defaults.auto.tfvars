suffix   = ""
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
node_admin_ssh_public_key = "~/.ssh/id_rsa.pub"
node_identity_type        = "SystemAssigned"

# Networking
# aks_dns_prefix        = var.name
aks_network_plugin    = "azure"
aks_load_balancer_sku = "Standard"
