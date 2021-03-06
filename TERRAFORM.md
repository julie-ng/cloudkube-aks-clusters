_This page is automatically generated by [terraform-docs.io](https://terraform-docs.io/)_

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 2.76.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster"></a> [cluster](#module\_cluster) | ./modules/aks-cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aks_disable_local_accounts"></a> [aks\_disable\_local\_accounts](#input\_aks\_disable\_local\_accounts) | n/a | `any` | n/a | yes |
| <a name="input_aks_dns_service_cidr"></a> [aks\_dns\_service\_cidr](#input\_aks\_dns\_service\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_aks_docker_bridge_cidr"></a> [aks\_docker\_bridge\_cidr](#input\_aks\_docker\_bridge\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_aks_load_balancer_sku"></a> [aks\_load\_balancer\_sku](#input\_aks\_load\_balancer\_sku) | n/a | `any` | n/a | yes |
| <a name="input_aks_network_plugin"></a> [aks\_network\_plugin](#input\_aks\_network\_plugin) | Networking (AKS) | `any` | n/a | yes |
| <a name="input_aks_service_cidr"></a> [aks\_service\_cidr](#input\_aks\_service\_cidr) | n/a | `any` | n/a | yes |
| <a name="input_aks_subnet_address_prefixes"></a> [aks\_subnet\_address\_prefixes](#input\_aks\_subnet\_address\_prefixes) | n/a | `any` | n/a | yes |
| <a name="input_azure_container_registry_admin_enabled"></a> [azure\_container\_registry\_admin\_enabled](#input\_azure\_container\_registry\_admin\_enabled) | n/a | `any` | n/a | yes |
| <a name="input_azure_container_registry_sku"></a> [azure\_container\_registry\_sku](#input\_azure\_container\_registry\_sku) | ACR | `any` | n/a | yes |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `any` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | n/a | `any` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | n/a | `any` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | AKS | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `any` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Log Analytics | `any` | n/a | yes |
| <a name="input_log_analytics_workspace_rg"></a> [log\_analytics\_workspace\_rg](#input\_log\_analytics\_workspace\_rg) | n/a | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `any` | n/a | yes |
| <a name="input_node_admin_ssh_public_key"></a> [node\_admin\_ssh\_public\_key](#input\_node\_admin\_ssh\_public\_key) | n/a | `any` | n/a | yes |
| <a name="input_node_admin_username"></a> [node\_admin\_username](#input\_node\_admin\_username) | n/a | `any` | n/a | yes |
| <a name="input_node_identity_type"></a> [node\_identity\_type](#input\_node\_identity\_type) | n/a | `any` | n/a | yes |
| <a name="input_nodes_enable_auto_scaling"></a> [nodes\_enable\_auto\_scaling](#input\_nodes\_enable\_auto\_scaling) | n/a | `any` | n/a | yes |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | n/a | `any` | n/a | yes |
| <a name="input_system_nodes_max_count"></a> [system\_nodes\_max\_count](#input\_system\_nodes\_max\_count) | n/a | `any` | n/a | yes |
| <a name="input_system_nodes_min_count"></a> [system\_nodes\_min\_count](#input\_system\_nodes\_min\_count) | n/a | `any` | n/a | yes |
| <a name="input_system_vm_size"></a> [system\_vm\_size](#input\_system\_vm\_size) | n/a | `any` | n/a | yes |
| <a name="input_tls_key_vault"></a> [tls\_key\_vault](#input\_tls\_key\_vault) | TLS Certs | `any` | n/a | yes |
| <a name="input_user_nodes_max_count"></a> [user\_nodes\_max\_count](#input\_user\_nodes\_max\_count) | n/a | `any` | n/a | yes |
| <a name="input_user_nodes_min_count"></a> [user\_nodes\_min\_count](#input\_user\_nodes\_min\_count) | n/a | `any` | n/a | yes |
| <a name="input_user_vm_size"></a> [user\_vm\_size](#input\_user\_vm\_size) | n/a | `any` | n/a | yes |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Networking (Azure) | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_summary"></a> [summary](#output\_summary) | n/a |
<!-- END_TF_DOCS -->