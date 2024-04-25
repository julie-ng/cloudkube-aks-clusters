variable "name" {
  type        = string
  description = "A base name used for all resources in this project (incl. dashes). Required."

  validation {
    condition     = length(var.name) < 20
    error_message = "Name must be less than 20 characters."
  }
}

variable "suffix" {
  type        = string
  description = "Suffix to avoid automation errors on Azure resources that require globally unique names. Defaults to empty string."
  default     = ""
}

variable "env" {
  type        = string
  description = "String used in all the naming conventions for TLS, DNS, etc."
  validation {
    condition     = contains(["dev", "staging", "prod"], var.env)
    error_message = "Must be one of 'dev', 'staging' or 'prod'."
  }
}

variable "hostname" {
  type        = string
  description = "Hostname for each environment, e.g. dev.cloudkube.io, required for ingress configuration."
}

variable "location" {
  type        = string
  description = "Location used for all resources in this project. Defaults to 'Central US'"
  default     = "Central US"
}

variable "default_tags" {
  type = map(string)
  default = {
    demo   = "true"
    public = "true"
  }
}

# Networking (Azure)
# ------------------

variable "vnet_address_space" {
  type        = list(string)
  description = "AKS Cluster Virtual Network Space"
}

variable "aks_subnet_address_prefixes" {
  type        = list(string)
  description = "Address space for subnet containing AKS nodes"
}

# Networking (AKS)
# ------------------

variable "aks_dns_prefix" {
  type    = string
  default = ""
}

variable "aks_network_plugin" {
  type = string
}

variable "aks_load_balancer_sku" {
  type    = string
  default = "standard"
}

variable "os_sku" {
  type    = string
  default = "AzureLinux"
}

# AKS
# ---

variable "system_node_pool_name" {
  type    = string
  default = "system"
}

variable "user_node_pool_name" {
  type    = string
  default = "user"
}

variable "kubernetes_version" {
  type = string
}

variable "system_vm_size" {
  type = string
}

variable "user_vm_size" {
  type = string
}

variable "nodes_enable_auto_scaling" {
  type = bool
}

variable "system_nodes_min_count" {
  type = number
}

variable "system_nodes_max_count" {
  type = number
}

variable "user_nodes_min_count" {
  type = number
}

variable "user_nodes_max_count" {
  type = number
}

variable "user_node_count" {
  type = number
}

variable "automatic_channel_upgrade" {
  type = string
}

variable "node_identity_type" {
  type = string
}

variable "node_admin_username" {
  type        = string
  description = "Admin username for cluster node VMs."
}

variable "node_admin_ssh_public_key" {
  type        = string
  description = "Public Key used for SSH access to node VMs."
}

variable "aks_service_cidr" {
  type        = string
  description = "Required for VNet integration"
}

variable "aks_docker_bridge_cidr" {
  type        = string
  description = "Required for VNet integration"
}

variable "aks_dns_service_cidr" {
  type        = string
  description = "Required for VNet integration"
}

variable "aks_disable_local_accounts" {
  type        = string
  description = "https://docs.microsoft.com/en-us/azure/aks/managed-aad#disable-local-accounts-preview"
}

# Key Vault
# ---------

variable "tls_key_vault" {} # shared rg

variable "key_vault_sku" {
  type    = string
  default = "standard"
}

variable "key_vault_enable_rbac_authorization" {
  type    = bool
  default = true
}

variable "key_vault_purge_protection_enabled" {
  type    = bool
  default = false # so we can fully delete it
}

variable "key_vault_soft_delete_retention_days" {
  type    = number
  default = 7 # minimum
}

# Log Analytics
variable "log_analytics_workspace_name" {}
variable "log_analytics_workspace_rg" {}
