# Terraform Remote State

This project uses different [Azure Storage Accounts](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction) for different environments. Multiple Storage Accounts serve as security boundaries. Per best practice production resources require elevated privileges, i.e. different credentials.

## Setup State Files

This assumes you already have an [Azure Storage Account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal).

1) **Create configuration files** by copying [backend.hcl.sample](./backend.hcl.sample) and renaming to:
   - `dev.backend.hcl`
   - `staging.backend.hcl`
   - `production.backend.hcl`

2) **Add [azurerm backend configuration](https://www.terraform.io/docs/language/settings/backends/azurerm.html)** for each file, for example:

```hcl
storage_account_name = "storageaccountname"
container_name       = "aks-clusters"
key                  = "dev.cluster.tfstate"
use_azuread_auth     = true     # option 1 (preferred)
sas_token            = "?se=…"  # option 2 
```

## Load Config on Init

When you initialize the terraform project, point it to the corresponding state file, for example:

```bash
terraform init -backend-config=backends/dev.backend.hcl
```

## Switching Environments

When we switch between clusters, we need to update the terraform configuration. For example, if we are changing to `staging`. 

First point to the staging backend configuration and `-reconfigure` the backend:

```bash
terraform init -backend-config=backends/staging.backend.hcl -reconfigure
```

Then use `-var-file` for terraform commands to pass staging specific configuration, e.g. getting current state:

```bash
terraform refresh -var-file=environments/staging/staging.cluster.tfvars
```

## Security

More details about this "real life" setup.

<img src="./../images/tf-state-rbac.svg" alt="Use different Storage Accounts for RBAC on Terraform State">

### Can I use different Shared Access Signatures (SAS) tokens for different state files in a single Storage Account?

Technically that would work. But then you lose the security boundary because the `terraform workspace` command looks for state files in your account and thus needs permissions scoped the account. An attacker would only need your non-production SAS token to find and access the production state file.

### Do not Use Terraform Workspaces for Environments

Terraform State has a built in "workspace" feature that lets you toggle between states. But per [Terraform documentation](https://www.terraform.io/docs/language/state/workspaces.html#when-to-use-multiple-workspaces), workspaces are not meant for targeting different environments:

> In particular, organizations commonly want to create a strong separation between multiple deployments of the same infrastructure serving different development stages (e.g. staging vs. production) or different internal teams. In this case, the backend used for each deployment often belongs to that deployment, with different credentials and access controls. **Named workspaces are not a suitable isolation mechanism for this scenario**.

Emphasis added. Please be aware workspace here refers to Terraform State, not Terraform Cloud, which is a completely different feature… with the same name 🤷‍♀️