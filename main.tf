# Setup
# -----
# Suffix to avoid errors on Azure resources that require globally unique names.

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Main
# ----

module "demos_dev" {
  source = "./environments/dev"
  name   = "aks-apps-dev"
  suffix = random_string.suffix.result
}

module "demos_prod" {
  source = "./environments/prod"
  name   = "aks-apps-prod-${random_string.suffix.result}"
}

# Outputs
# -------

output "dev_summary" {
  value = module.demos_dev.summary
}

output "prod_summary" {
  value = module.demos_prod.summary
}