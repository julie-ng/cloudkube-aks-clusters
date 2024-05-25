locals {
  name          = lower(var.name)
  name_suffixed = lower("${var.name}%{if var.suffix != ""}-${var.suffix}%{endif}")
}

# Kubernetes Resources
# ====================

# Namespace
resource "kubernetes_namespace" "workload" {
  metadata {
    name = local.name
  }
}

# Service Account
resource "kubernetes_service_account" "workload" {
  metadata {
    name      = "${local.name}-workload"
    namespace = kubernetes_namespace.workload.metadata[0].name
    annotations = {
      "azure.workload.identity/client-id" = azurerm_user_assigned_identity.workload_mi.client_id
    }
  }
}

# Azure Resources
# ===============

# Reference to resource group to save our managed identities
data "azurerm_resource_group" "cluster" {
  name = var.resource_group_name
}

# Managed identity
resource "azurerm_user_assigned_identity" "workload_mi" {
  name                = "${local.name_suffixed}-workload-mi"
  resource_group_name = data.azurerm_resource_group.cluster.name
  location            = data.azurerm_resource_group.cluster.location
}

# Federated credential
resource "azurerm_federated_identity_credential" "workload_mi" {
  name                = "${local.name}-workload"
  resource_group_name = data.azurerm_resource_group.cluster.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.aks_oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.workload_mi.id
  subject             = "system:serviceaccount:${kubernetes_namespace.workload.metadata[0].name}:${kubernetes_service_account.workload.metadata[0].name}"
}
