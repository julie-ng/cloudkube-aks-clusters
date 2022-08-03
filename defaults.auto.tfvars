suffix        = ""
suffix_length = 4
location      = "northeurope"

default_tags = {
  env    = "dev"
  iac    = "terraform"
  demo   = "true"
  public = "true"
}

# AKS Config
kubernetes_version        = "1.19.7"
nodes_enable_auto_scaling = true
automatic_channel_upgrade = "patch"

# ==========
#  VM Sizing
# ==========
# For sizes, e.g. `Standard_DS2_v2` see:
# https://docs.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions
# https://docs.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series

# System Node Pool
system_vm_size         = "Standard_B2ms"
system_nodes_min_count = 1
system_nodes_max_count = 2

# User Node Pool
user_vm_size         = "Standard_B2ms"
user_nodes_min_count = 1
user_nodes_max_count = 3
user_node_count      = 1

# Accounts
node_admin_username       = "ubuntu"
node_admin_ssh_public_key = "~/.ssh/id_rsa.pub"
node_identity_type        = "SystemAssigned"

# Networking
# aks_dns_prefix        = var.name
aks_network_plugin    = "azure"
aks_load_balancer_sku = "standard"

# Log Analytics
log_analytics_workspace_name = "cloudkube-log-analytics"
log_analytics_workspace_rg   = "cloudkube-shared-rg"
