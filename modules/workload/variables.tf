variable "name" {
  type = string
}

variable "suffix" {
  type        = string
  description = "Suffix to append to Azure resources for subscription/tenant-wide unique names. Will not be used on k8s resources."
}

variable "resource_group_name" {
  type        = string
  description = "Resource group to for managed identities. Use RG of AKS cluster."
}

variable "aks_oidc_issuer_url" {
  type        = string
  description = "OIDC issuer url of an AKS cluster with workload identities enabled."
}
