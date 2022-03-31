# See modules/aks-lcuster/variables.tf for descriptions

variable "name" {}
variable "env" {}
variable "suffix" {}
variable "suffix_length" {}
variable "hostname" {}
variable "location" {}
variable "default_tags" {}

# Networking (Azure)
variable "vnet_address_space" {}
variable "aks_subnet_address_prefixes" {}

# Networking (AKS)
variable "aks_network_plugin" {}
variable "aks_load_balancer_sku" {}

# AKS
variable "kubernetes_version" {}
variable "system_vm_size" {}
variable "user_vm_size" {}

variable "nodes_enable_auto_scaling" {}
variable "system_nodes_min_count" {}
variable "system_nodes_max_count" {}
variable "user_nodes_min_count" {}
variable "user_nodes_max_count" {}
variable "user_node_count" {}

variable "node_identity_type" {}
variable "node_admin_username" {}
variable "node_admin_ssh_public_key" {}
variable "aks_service_cidr" {}
variable "aks_docker_bridge_cidr" {}
variable "aks_dns_service_cidr" {}
variable "aks_disable_local_accounts" {}
variable "automatic_channel_upgrade" {}

# ACR
variable "azure_container_registry_sku" {}
variable "azure_container_registry_admin_enabled" {}

# TLS Certs
variable "tls_key_vault" {}

# Log Analytics
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_rg" {}
