# aks-demo-apps

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

## Setup

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

### Required Pre-existing Azure Resources

The following resources should already exist before creating a cluster. They are not created here because they have a different lifecycle. For example we want IPs to persist for our DNS records.

- Static IP for cluster
- Key Vault with TLS certificates?

### Setup Cluster in 5 Easy Commands

Initialize and create a deployment plan

```
terraform init
terraform plan -out plan.tfplan
```

If you are satisified with the plan, deploy it

```
terraform apply plan.tfplan
```

Then set Kubernetes context to use `kubectl` 

```bash
make kubecontext
make setup
```

### Post Cluster Setup - Deploy Hello World

Deploy a hello world app to [http://dev.cloudkube.io](http://dev.cloudkube.io)

```
kubectl apply -f manifests/hello-world/
```


## Debugging

### AAD Pod Identity MIC Logs

```
kubectl logs --follow -l "app.kubernetes.io/component=mic" --since=1h -n azure-pod-identity
```

#### Abbreviations

- Managed Identity Controller (MIC)
- Node Managed Identity (NMI) 

