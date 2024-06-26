suffix        = ""
suffix_length = 4
location      = "eastus"

default_tags = {
  env  = "dev"
  iac  = "terraform"
  demo = "true"
}

# AKS Config
kubernetes_version         = "1.28.5"
automatic_channel_upgrade  = "patch"
nodes_enable_auto_scaling  = true
aks_disable_local_accounts = true

# ==========
#  VM Sizing
# ==========
# For sizes, e.g. `Standard_DS2_v2` see:
# https://docs.microsoft.com/en-us/azure/virtual-machines/vm-naming-conventions
# https://docs.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series

os_sku = "AzureLinux"

# System Node Pool
system_node_pool_name  = "system"
system_vm_size         = "standard_d2s_v3"
system_nodes_min_count = 1
system_nodes_max_count = 2

# User Node Pool
user_node_pool_name  = "workloads"
user_vm_size         = "standard_d2s_v3"
user_nodes_min_count = 1
user_nodes_max_count = 3
user_node_count      = 1

# Accounts
node_admin_username       = "ubuntu"
node_admin_ssh_public_key = "~/.ssh/id_rsa.pub"
node_identity_type        = "SystemAssigned"

# Networking
aks_network_plugin    = "azure"
aks_load_balancer_sku = "standard"

# Log Analytics
log_analytics_workspace_name = "cloudkube-log-analytics"
log_analytics_workspace_rg   = "cloudkube-shared-rg"
