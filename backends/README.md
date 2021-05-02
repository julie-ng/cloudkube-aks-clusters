# Terraform Remote State

This project uses different [Azure Storage Accounts](https://docs.microsoft.com/azure/storage/blobs/storage-blobs-introduction) for different environments. Multiple Storage Accounts serve as security boundaries. Per best practice production resources require elevated privileges, i.e. different credentials.

<img src="./../images/tf-state-rbac.svg" alt="Use different Storage Accounts for RBAC on Terraform State">

#### Can I use different Shared Access Signatures (SAS) tokens for different state files in a single Storage Account?

Technically that would work. But then you lose the security boundary because the `terraform workspace` command looks for state files in your account and thus needs permissions scoped the account. An attacker would only need your non-production SAS token to find and access the production state file.

#### Do not Use Terraform Workspaces for Environments

Terraform State has a built in "workspace" feature that lets you toggle between states. But per [Terraform documentation](https://www.terraform.io/docs/language/state/workspaces.html#when-to-use-multiple-workspaces), workspaces are not meant for targeting different environments:

> In particular, organizations commonly want to create a strong separation between multiple deployments of the same infrastructure serving different development stages (e.g. staging vs. production) or different internal teams. In this case, the backend used for each deployment often belongs to that deployment, with different credentials and access controls. **Named workspaces are not a suitable isolation mechanism for this scenario**.

Emphasis added. Please be aware workspace here refers to Terraform State, not Terraform Cloud, which is a completely different feature… with the same name 🤷‍♀️

## Setup Accounts and State Files

### Create Configuration Files

Copy [backend.hcl.sample](./backend.hcl.sample) and rename to:

- `dev.backend.hcl`
- `staging.backend.hcl`
- `production.backend.hcl`

Each file should have a different [azurerm backend configuration](https://www.terraform.io/docs/language/settings/backends/azurerm.html):

```
storage_account_name="storageaccountname"
container_name="aks-clusters"
key="dev.cluster.tfstate"
sas_token="?se=…"
```

### Load Config on Init

When you initialize the terraform project, point it to the corresponding state file, for example:

```bash
terraform init -backend-config=backends/dev.backend.hcl
```


# Create Storage Accounts for Terraform State

If you don't have any storage accounts, follow the instructions below. **You will have to run it at least twice to create 2 different accounts** for non-production state files and production statefiles.

## Create a Storage Acount

If you need to create a storage account for your Terraform state files, you can do so with the Azure CLI.

Configure some resource names to your liking:

```bash
export AZ_CLOUDKUBE_STATE_RG_NAME=terraform-workspaces-rg
export AZ_CLOUDKUBE_STATE_STORAGEACCT_NAME=yourstorageaccountname  # must be globally unique
export AZ_CLOUDKUBE_STATE_CONTAINER_NAME=aks-clusters  
export AZ_CLOUDKUBE_STATE_LOCATION=centralus
```

### Create a Resource Group

We'll create a dedicated resource group for our state files.

```bash
az group create \
    --name $AZ_CLOUDKUBE_STATE_RG_NAME \
    --location $AZ_CLOUDKUBE_STATE_LOCATION
```

### Create a Storage Account

This holds your actual Terraform state file. Note that we **explicitly disable public access**.

```bash
az storage account create \
    --name $AZ_CLOUDKUBE_STATE_STORAGEACCT_NAME \
    --resource-group $AZ_CLOUDKUBE_STATE_RG_NAME \
    --kind StorageV2 \
    --sku Standard_LRS \
    --https-only true \
    --allow-blob-public-access false
```

### Create a Blob Storage Container

Blobs always need a parent container.

```bash
az storage container create \
    --name $AZ_CLOUDKUBE_STATE_CONTAINER_NAME \
    --account-name $AZ_CLOUDKUBE_STATE_STORAGEACCT_NAME \
    --public-acces off \
    --auth-mode login
```

### Create Shared Access Signature 

Instead of using the access key, we will create a Shared Access Signature (SAS) token that expires in 7 days.

```bash
az storage account generate-sas \
    --permissions cdlruwap \
    --account-name $AZ_CLOUDKUBE_STATE_STORAGEACCT_NAME \
    --services b \
    --resource-types sco  \
    --expiry $(date -v+7d '+%Y-%m-%dT%H:%MZ') \
    -o tsv
```