# dev.cloudkube.io

See [`defaults.auto.tfvars`](./../../defaults.auto.tfvars) for cluster default configuration.

Contains ***dev*** cluster specific configuration, for example
- Kubernetes version
- Number of nodes
- Which Key Vault TLS certifications for ingress?
- Dev cluster address space (each cluster should have unique space if you plan on peering them)
