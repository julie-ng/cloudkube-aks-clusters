output "kubernetes_service_account" {
  value = {
    metadata                        = kubernetes_service_account.workload.metadata[0]
    automount_service_account_token = kubernetes_service_account.workload.automount_service_account_token
  }
}

output "managed_identity" {
  value = {
    name                = azurerm_user_assigned_identity.workload_mi.name
    client_id           = azurerm_user_assigned_identity.workload_mi.client_id
    resource_group_name = azurerm_user_assigned_identity.workload_mi.resource_group_name
    id                  = azurerm_user_assigned_identity.workload_mi.id
  }
}

output "federated_credential" {
  value = {
    id       = azurerm_federated_identity_credential.workload_mi.id
    name     = azurerm_federated_identity_credential.workload_mi.name
    issuer   = azurerm_federated_identity_credential.workload_mi.issuer
    subject  = azurerm_federated_identity_credential.workload_mi.subject
    audience = azurerm_federated_identity_credential.workload_mi.audience
  }
}
