variable "name" {}
variable "env" {}
variable "suffix" {}
variable "suffix_length" {}
variable "hostname" {}
variable "location" {}
variable "default_tags" {}

# Networking (AKS)
variable "aks_network_plugin" {}
variable "aks_load_balancer_sku" {}

# AKS
variable "kubernetes_version" {}
variable "os_sku" {}
variable "automatic_channel_upgrade" {}
variable "nodes_enable_auto_scaling" {}
variable "node_identity_type" {}
variable "node_admin_username" {}
variable "node_admin_ssh_public_key" {}
variable "aks_disable_local_accounts" {}

# system node pool
variable "system_node_pool_name" {}
variable "system_vm_size" {}
variable "system_nodes_min_count" {}
variable "system_nodes_max_count" {}

# user node pool
variable "user_node_pool_name" {}
variable "user_vm_size" {}
variable "user_nodes_min_count" {}
variable "user_nodes_max_count" {}
variable "user_node_count" {}

# TLS Certs
variable "tls_key_vault" {}

# Log Analytics
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_rg" {}
