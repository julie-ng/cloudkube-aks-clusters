resource "azurerm_resource_group" "cluster" {
  name     = "${local.name}-rg"
  location = var.location
  tags     = var.default_tags
}