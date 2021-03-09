# Suffix to avoid errors on Azure resources that require globally unique names.

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Main
# ----

module "demos_cluster" {
	source 		= "./cluster"
	base_name = "aks-apps"
	suffix 		= random_string.suffix.result
}

output "summary" {
	value = module.demos_cluster.summary
}