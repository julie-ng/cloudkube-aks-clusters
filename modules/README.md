# `aks-cluster` module

This module creates the AKS cluster and is used to bring up multiple environments.

### How to use

For a full examples, see [main.tf](./../main.tf)

```hcl
module "cluster" {
  source               = "./modules/aks-cluster"
  name                 = "my-cluster"
  suffix               = "123"
  kubernetes_version   = "1.19.7"
  vm_size              = "Standard_DS2_v2"
  # … 
}
```

## AAD Pod Identity

Per [official installation instructions](https://azure.github.io/aad-pod-identity/docs/getting-started/role-assignment/) there are some Role Assignments that have to be created **_before_ installing AAD pod identity**.

### Required Role Assignments Before Installing

AKS assumes the identities are in the same resource group as the AKS nodes, i.e. the `dev-cluster-managed-rg` and needs extra permissions at this scope. There are at least 2 required roles assignments:

- **Principal - kubelet**   
  Kubelet Managed Identity is the primary "node agent" that will be managing all the identity assignments. Not managed by Terraform.

- **Scope - managed resource group**  
  AKS Nodes Resource group, which by default starts with `MC_`. The clusters created in this project use instead a suffix of `-managed-rg`. Not managed by Terraform.

- **Roles**
  - [Managed Identity Operator](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#managed-identity-operator)
  - [Virtual Machine Contributor](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#virtual-machine-contributor)

_(Optional)_ if the identities are in _another_ resource group, the kubelet also needs "Managed Identity Operator" role on that resource group.

### Kubenet not Supported

- AAD Pod Identity has [breaking change since v1.7.x](https://azure.github.io/aad-pod-identity/docs/#v17x-breaking-change) which means it no longer supports Kubenet
- You can go around it by installing Open Policy Agent

### [Open Policy Agent]((https://www.openpolicyagent.org/)) Gatekeeper

#### Policies

#### Prevent `NET_RAW`

By Default AAD Pod Identity is not available when using Kubenet because

> Kubenet network plugin is susceptible to ARP spoofing. This makes it possible for pods to impersonate as a pod with access to an identity. Using CAP_NET_RAW capability the attacker pod could then request token as a pod it’s impersonating.

Source: [AAD Pod Identity Docs - Why this change?](https://azure.github.io/aad-pod-identity/docs/configure/aad_pod_identity_on_kubenet/)

To make it owrk, I had o

```yaml
# https://azure.github.io/aad-pod-identity/docs/configure/aad_pod_identity_on_kubenet/
apiVersion: constraints.gatekeeper.sh/v1beta1
kind: K8sPSPCapabilities
metadata:
  name: prevent-net-raw
spec:
  match:
    kinds:
      - apiGroups: [""]
        kinds: ["Pod"]
    excludedNamespaces:
      - "gatekeeper-system"
      - "kube-system"
      - "azure-pod-identity"
      - "azure-csi"
      - "ingress"
  parameters:
    requiredDropCapabilities: ["NET_RAW"]
```

#### Gotcha - Directory name

The folder with the policies cannot be named `gatekeeper` due to [hashicorp/terraform-provider-helm/issues/509](https://github.com/hashicorp/terraform-provider-helm/issues/509). Mine was named `gatekeeper-policies`.

# Debugging

### AAD Pod Identity MIC Logs

```
kubectl logs --follow -l "app.kubernetes.io/component=mic" --since=1h -n azure-pod-identity
```
