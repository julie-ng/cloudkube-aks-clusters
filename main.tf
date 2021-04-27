terraform {
  backend "azurerm" {}
}

# Setup
# -----
# Suffix to avoid errors on Azure resources that require globally unique names.

resource "random_string" "suffix" {
  length      = 4
  min_lower   = 3
  min_numeric = 1
  special     = false
  upper       = false
  number      = true
}

# Main
# ----

module "dev" {
  source = "./environments/dev"
  name   = "cloudkube-dev"
  suffix = random_string.suffix.result
}

# module "demos_prod" {
#   source = "./environments/prod"
#   name   = "aks-apps-prod-${random_string.suffix.result}"
# }

# Outputs
# -------

output "dev_summary" {
  value = module.dev.summary
}

# output "prod_summary" {
#   value = module.demos_prod.summary
# }
