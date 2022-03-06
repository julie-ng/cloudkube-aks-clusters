name                        = "cloudkube-dev"
env                         = "dev"
hostname                    = "dev.cloudkube.io"
vnet_address_space          = ["10.0.0.0/16"]
aks_subnet_address_prefixes = ["10.0.2.0/24"]
aks_disable_local_accounts  = true

# Required VNet integration config
aks_service_cidr       = "10.0.1.0/24"
aks_dns_service_cidr   = "10.0.1.10"
aks_docker_bridge_cidr = "170.10.0.1/16"

# shared-rg
tls_key_vault = {
  name           = "cloudkube-dev-kv"
  resource_group = "cloudkube-shared-rg"
}

kubernetes_version = "1.20.15"
system_vm_size     = "Standard_B2ms"
user_vm_size       = "Standard_B2ms"
