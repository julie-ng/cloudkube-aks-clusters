# ===================
#  Cluster Key Vault
# ===================

resource "azurerm_key_vault" "cluster_kv" {
  name                       = "${local.name_suffixed}-kv"
  location                   = azurerm_resource_group.cluster_rg.location
  resource_group_name        = azurerm_resource_group.cluster_rg.name
  sku_name                   = var.key_vault_sku
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled
  tags                       = var.default_tags
  enable_rbac_authorization  = var.key_vault_enable_rbac_authorization
}

# Test Secret
# -----------

resource "azurerm_key_vault_secret" "test" {
  name         = "hello"
  value        = "hello world"
  content_type = "text/plain"
  key_vault_id = azurerm_key_vault.cluster_kv.id

  depends_on = [
    azurerm_role_assignment.kv_admin # don't try to create until we have access
  ]
}

# Source TLS Certs
# ----------------

data "azurerm_key_vault" "shared_kv" {
  name                = var.tls_key_vault.name
  resource_group_name = var.tls_key_vault.resource_group
}
