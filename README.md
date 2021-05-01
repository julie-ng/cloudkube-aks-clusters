# cloudkube.io - AKS Clusters

An opinionated Azure Kubernetes Service (AKS) cluster for running demo apps.

### Features

- Virtual Network integration
- Azure CNI Networking
- Ingress with ingress-nginx
- Installs azure-csi
- Installs aad-pod-identity
  - includes required role assignments `Virtual Machine Contributor` and `Managed Identity Operator`

### Opinionated Customizations

- Prefer `-managed-rg` suffix over default `MC_` prefix for resource group containing managed cluster
- Install addons using `Makefile` instead of lots of bash-fu

# Setup 

Up and running with just 5 commands

## 1) Requirements

### Client Requirements

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

### Shared Infra Requirements

The following Azure resources are located in a separate Resource Group `cloudkube-shared-rg` and managed by the [`cloudkube-shared-infra`](https://github.com/julie-ng/cloudkube-shared-infra) repository:

- DNS Records
- Key Vaults
- Role Assignments to access TLS Certificates

## 2) Deploy AKS Clusters

Initialize and create a deployment plan

```bash
terraform init
terraform plan -out plan.tfplan
```

If you are satisified with the plan, deploy it

```bash
terraform apply plan.tfplan
```

## 3) Setup Ingress

To let `make` know, which AKS cluster we want to configure, we set the `CLOUDKUBE_TARGET` environment variable. Value should be `dev`, `staging` or `prod`.

```bash
export CLOUDKUBE_TARGET=dev
```

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

## Naming Conventions

### Environments 

Resources names will include one of

- `dev`
- `staging`
- `prod`

### Hosts

- [dev.cloudkube.io](https://dev.cloudkube.io)
- [staging.cloudkube.io](https://staging.cloudkube.io)
- [cloudkube.io](https://cloudkube.io)

# References

Official Documentation

### Azure

- [Azure Docs - Key Vault Roles](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli)
- [AKS Docs - Summary of Managed Identities](https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#summary-of-managed-identities)

### AAD Pod Identity

- [Getting Started > Role Assignments](https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/)
- [Helm Chart on Artifact Hub](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx)
- [Helm Chart Configuration on GitHub](https://github.com/Azure/aad-pod-identity/tree/master/charts/aad-pod-identity#configuration)


### Azure CSI

- Note: Secret is not created until ingress controller is deployed.
	>  A Kubernetes secret ingress-tls-csi will be created by the CSI driver as a result of ingress controller creation.

### Ingress Controller (nginx)

- [Helm Chart](https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx) on Artifact Hub
- [Helm Chart Source](https://github.com/kubernetes/ingress-nginx) on GitHub.com
  - [values.yaml](https://github.com/kubernetes/ingress-nginx/blob/master/charts/ingress-nginx/values.yaml)
- [Officla Docs/Website](https://kubernetes.github.io/ingress-nginx)