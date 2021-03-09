resource "azurerm_resource_group" "cluster" {
  name     = "${local.base_name}-rg"
  location = var.location
  tags     = var.default_tags
}