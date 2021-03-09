module "demos_cluster" {
  source = "./../../modules/cluster"
  name   = var.name
  suffix = var.suffix
  default_tags = {
    env    = "dev"
    demo   = "true"
    public = "true"
  }
}

# Outputs

output "summary" {
  value = module.demos_cluster.summary
}