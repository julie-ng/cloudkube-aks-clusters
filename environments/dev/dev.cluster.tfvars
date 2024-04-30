name     = "cloudkube-dev"
env      = "dev"
hostname = "dev.cloudkube.io"
location = "eastus"

# shared-rg
tls_key_vault = {
  name           = "cloudkube-dev-kv"
  resource_group = "cloudkube-shared-rg"
}

# Kubernetes Version
# See also https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#aks-kubernetes-release-calendar
kubernetes_version = "1.27.7"
