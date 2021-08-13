# cloudkube.io - AKS Clusters

An opinionated Azure Kubernetes Service (AKS) cluster for running demo apps, leveraging `Makefile` instead of lots of bash-fu to install AKS add-ons.

## Architecture

The following diagram illustrates the Azure solution architecture for _each cluster_, e.g. dev, staging and prod.

![Cloudkube.io AKS Cluster](./images/architecture.png)

### Architecture Decisions

- Virtual Network integration
- Azure CNI Networking
- [NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
- [Azure Key Vault Provider for Secrets Store CSI Driver](https://azure.github.io/secrets-store-csi-driver-provider-azure/)
- [Azure AD Pod Identity](https://azure.github.io/aad-pod-identity/) 
  - Assigns Azure Active Directory Identities to Ingress Controller pods to fetch TLS certificates from an [externally managed Key Vault](https://github.com/julie-ng/cloudkube-shared-infra). These Key Vaults are in a different IaC repo and resource group because they have a different resource lifecycle.
  - Includes [required role assignments](./modules/README.md#aad-pod-identity) `Virtual Machine Contributor` and `Managed Identity Operator`
- Prefer `-managed-rg` suffix over default `MC_` prefix for resource group containing managed cluster

### Managed Identities - Why You Need 3

| Managed Identity | Security Principal | Details |
|:--|:--|:--|
| `cluster-mi` | AKS Service, IaaS | Belongs to cluster-rg because its lifecycle is outside of the managed cluster (`azure-managed-rg`), which can be torn down and re-deployed, e.g. to access new AKS features. | 
| `agentpool-mi` | Virtual Machine, IaaS | Used by Azure managed Infra to pull images from Container Registry to deploy pods |
| `ingres-pod-mi` | Ingress, Workload | An extra identity by a customer workload (ingress) to get TLS certificates from Key Vault in a different resource group - a customer specific, non-Azure requirement. |
  
### Environments 

Resources names will include one of

- `dev`
- `staging`
- `prod`

### Hosts

- [dev.cloudkube.io](https://dev.cloudkube.io)
- [staging.cloudkube.io](https://staging.cloudkube.io)
- [cloudkube.io](https://cloudkube.io)

# Setup and Configure 

Using Terraform and make commands, you will have an AKS cluster with all the Azure CSI and Pod Identity Add-Ons up and running with just 5 commands.

## 1) Requirements

### CLI Tools (Required)

In order to deploy AKS clusters using IaC in this repository, you will need the following command line tools:

- [terraform](https://www.terraform.io/docs/cli/index.html)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [helm 3](https://helm.sh/)
- [make](https://www.gnu.org/software/make/)
- [envsubst](https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html)  
  Install on a mac
	```bash
	brew install gettext
	brew link --force gettext
	```
  Install on Ubuntu
	```bash
	apt-get install gettext-base
	```

### Shared Infrastructure (Required)

The following Azure resources are located in a separate Resource Group `cloudkube-shared-rg` and managed by the [`cloudkube-shared-infra`](https://github.com/julie-ng/cloudkube-shared-infra) repository:

- DNS Records
- Key Vaults
- Role Assignments to access TLS Certificates

Without these resources, the setup of the Ingress controller will fail as it wants to configure TLS encryption.

### Storage Accounts for Terraform State Files (Optional)

This is not necessary if you just want to deploy and manage a single cluster from your local machine. In cloudkube.io use case, this infrastructure as code (IaC) repo is used to manage 3 distinct AKS clusters and will be integrated with CI/CD. 

And to comply with governance best practices, we have 2 different storage accounts to create a security boundary between production and non-production resources.

[<img src="./images/tf-state-rbac.svg" width="460" alt="Use different Storage Accounts for RBAC on Terraform State">](./backends/README.md)

_Diagram: use different Storage Accounts for RBAC on Terraform State. See [backends/README.md](./backends/README.md) for details._

## 2) Deploy AKS Cluster

#### terraform init

First initialize the remote backend and specify which environment, e.g. `backends/dev.backend.hcl`

```bash
terraform init -backend-config=backends/dev.backend.hcl
```

If you dont' want to deal with remote and multiple environments, you can leave out the `-backend-config` flag.

#### terraform plan

Now create a infrastructure plan. Specify environment configuration with `var-file` flag pointing to e.g. `environments/dev.tfvars`

```bash
terraform plan -var-file=environments/dev.tfvars -out plan.tfplan
```

#### terraform apply

If you are satisified with the plan, deploy it

```bash
terraform apply plan.tfplan
```

## 3) Setup Ingress

Finally finish cluster setup with

```bash
make kubecontext
make setup
```

which will
- install Azure CSI driver
- install Azure Pod Identity 
- setup namespaces
- install nginx ingress controller
- setup and configure "hello world" app
- configure TLS by pull certificates from shared Key Vault

See [Makefile](./Makefile) for details.

# References

Official Documentation

### Terraform

- [Terraform Docs - Organizing Multiple Environments for a Configuration](https://www.terraform.io/docs/cloud/workspaces/configurations.html#organizing-multiple-environments-for-a-configuration)
- [Terraform Docs - When to use Multiple Workspaces](https://www.terraform.io/docs/language/state/workspaces.html#when-to-use-multiple-workspaces)
- [Terraform Docs - Variable Definition Precedence](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence)

### Azure

- [Azure Key Vault - Roles](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli)
- [Azure Kubernetes Service - Summary of Managed Identities](https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#summary-of-managed-identities)
- **[Azure AD Pod Identity](https://azure.github.io/aad-pod-identity/)**
	- [Getting Started > Role Assignments](https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/)
	- [Helm Chart on Artifact Hub](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)
	- [Helm Chart Configuration on GitHub](https://github.com/Azure/aad-pod-identity/tree/master/charts/aad-pod-identity#configuration)
- **[Azure CSI](https://azure.github.io/secrets-store-csi-driver-provider-azure/)**
	- [Standard Walkthrough](https://azure.github.io/secrets-store-csi-driver-provider-azure/demos/standard-walkthrough/)
	- [Enable NGINX Ingress Controller with TLS](https://azure.github.io/secrets-store-csi-driver-provider-azure/configurations/ingress-tls/)

### Nginx Ingress Controller

- [Kubernetes Docs - NGINX Ingress Controller](https://kubernetes.github.io/ingress-nginx)
- [Helm Chart](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx) on Artifact Hub
- [Helm Chart Source](https://github.com/kubernetes/ingress-nginx) on GitHub.com
  - [values.yaml](https://github.com/kubernetes/ingress-nginx/blob/master/charts/ingress-nginx/values.yaml)
