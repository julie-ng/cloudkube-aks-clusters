name          = "cloudkube-staging"
env           = "staging"
hostname      = "staging.cloudkube.io"
location      = "eastus"
suffix_length = 3
# suffix = "1bp"

# shared-rg
tls_key_vault = {
  name           = "cloudkube-staging-kv"
  resource_group = "cloudkube-shared-rg"
}

# Kubernetes Version
kubernetes_version = "1.27.7"

