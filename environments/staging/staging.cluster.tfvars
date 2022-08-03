name     = "cloudkube-staging"
env      = "staging"
hostname = "staging.cloudkube.io"
location = "norwayeast"
suffix   = "fi9" # tf random 3 chars are weird

vnet_address_space          = ["10.0.0.0/16"]
aks_subnet_address_prefixes = ["10.0.2.0/24"]
aks_disable_local_accounts  = true

# Required VNet integration config
aks_service_cidr       = "10.0.1.0/24"
aks_dns_service_cidr   = "10.0.1.10"
aks_docker_bridge_cidr = "170.10.0.1/16"

# shared-rg
tls_key_vault = {
  name           = "cloudkube-staging-kv"
  resource_group = "cloudkube-shared-rg"
}

kubernetes_version = "1.21.7"
system_vm_size     = "Standard_DS2_v2"
user_vm_size       = "Standard_DS2_v2"
