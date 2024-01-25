# =========== #
#  Interface  #
# =========== #

BLACK        := $(shell tput -Txterm setab 0 && tput -Txterm setaf 7)
RED          := $(shell tput -Txterm setab 1 && tput -Txterm setaf 0)
GREEN        := $(shell tput -Txterm setab 2 && tput -Txterm setaf 0)
YELLOW       := $(shell tput -Txterm setab 3 && tput -Txterm setaf 0)
LIGHTPURPLE  := $(shell tput -Txterm setab 4 && tput -Txterm setaf 0)
PURPLE       := $(shell tput -Txterm setab 5 && tput -Txterm setaf 7)
BLUE         := $(shell tput -Txterm setab 4 && tput -Txterm setaf 0)
WHITE        := $(shell tput -Txterm setab 7 && tput -Txterm setaf 0)
RESET        := $(shell tput -Txterm sgr0)
BLUE_TEXT    := $(shell tput -Txterm setaf 4)
RED_TEXT     := $(shell tput -Txterm setaf 1)
YELLOW_TEXT  := $(shell tput -Txterm setaf 3)

# ================== #
#  Environment Vars  #
# ================== #

.EXPORT_ALL_VARIABLES:

AKS_ENV_NAME=$(shell terraform output -json summary | jq -r .env)
AKS_ENV_HOSTNAME=$(shell terraform output -json summary | jq -r .hostname)
AKS_SUBSCRIPTION_ID=$(shell terraform output -json summary | jq -r .azure_subscription.id)
AKS_TENANT_ID=$(shell terraform output -json summary | jq -r .azure_subscription.tenant_id)
AKS_RG_NAME=$(shell terraform output -json summary | jq -r .resource_group.name)
AKS_NODE_RG_NAME=$(shell terraform output -json summary | jq -r .aks_cluster.node_rg)
AKS_CLUSTER_NAME=$(shell terraform output -json summary | jq -r .aks_cluster.name)
KUBELET_MI_CLIENT_ID=$(shell terraform output -json summary | jq -r .managed_identities.kubelet.client_id)
INGRESS_MI_NAME=$(shell terraform output -json summary | jq -r .aks_cluster.ingress_mi.name)
INGRESS_MI_CLIENT_ID=$(shell terraform output -json summary | jq -r .aks_cluster.ingress_mi.client_id)
INGRESS_MI_RESOURCE_ID=$(shell terraform output -json summary | jq -r .aks_cluster.ingress_mi.id)
INGRESS_STATIC_IP=$(shell terraform output -json summary | jq -r .aks_cluster.static_ingress_ip)
CLUSTER_KV_NAME=$(shell terraform output -json summary | jq -r .key_vault.name)
KEY_VAULT_CSI_CHART_VERSION=1.5.1
INGRESS_CHART_VERSION=4.8.0 # older version works with Azure…  4.7 supposedly works, but need 4.8 for aks 1.28
INGRESS_NAMESPACE=ingress

# Key Vault Provider CSI Chart Versions
# https://github.com/Azure/secrets-store-csi-driver-provider-azure/tree/master/charts/csi-secrets-store-provider-azure

# Ingress Chart versions
# https://github.com/kubernetes/ingress-nginx/releases


# ========= #
#  Scripts  #
# ========= #

# Get AKS Credentials

kubecontext:
	@echo "${PURPLE} Kubernetes ${RESET} Set Kubernetes context"
	az aks get-credentials \
		--resource-group ${AKS_RG_NAME} \
		--name ${AKS_CLUSTER_NAME}
	kubelogin convert-kubeconfig -l azurecli
	kubectl get pods --all-namespaces


# All the commands
# ----------------

setup: create-namespaces install-azure-kv-csi install-ingress
uninstall: uninstall-ingress uninstall-azure-kv-csi delete-namespaces


# Namespaces
# ----------

create-namespaces:
	@echo ""
	@echo "${PURPLE} Namespaces ${RESET} ${YELLOW_TEXT}create${RESET}"
	kubectl apply -f manifests/namespaces/

delete-namespaces:
	@echo ""
	@echo "${PURPLE} Namespaces ${RESET} ${RED_TEXT}delete${RESET}"
	kubectl delete -f manifests/namespaces/


# CSI Driver
# ----------

install-azure-kv-csi:
	@echo ""
	@echo "${BLUE} Azure CSI ${RESET} ${YELLOW_TEXT}helm install${RESET}"
	helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts
	helm repo update
	helm upgrade azure-kv-csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure \
		--set secrets-store-csi-driver.syncSecret.enabled=true \
		--version $$KEY_VAULT_CSI_CHART_VERSION \
		--namespace kube-system \
		--install

uninstall-azure-kv-csi:
	@echo ""
	@echo "${BLUE} Azure CSI ${RESET} ${RED_TEXT}helm uninstall${RESET}"
	helm uninstall azure-kv-csi --namespace kube-system


# Ingress Controller
# ------------------

install-ingress: sync-certs install-ingress-chart apply-hello
uninstall-ingress: remove-hello uninstall-ingress-chart unsync-certs

sync-certs:
	@cat ./manifests/ingress/secret-provider-classes.yaml | envsubst | kubectl apply -f -

unsync-certs:
	@cat ./manifests/ingress/secret-provider-classes.yaml | envsubst | kubectl delete -f -

install-ingress-chart:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${YELLOW_TEXT}helm install${RESET}"
	cat ./manifests/ingress/chart.values.yaml | envsubst | helm upgrade \
		--install ingress-basic ingress-nginx \
		--repo https://kubernetes.github.io/ingress-nginx \
		--namespace $$INGRESS_NAMESPACE \
		--version $$INGRESS_CHART_VERSION \
		--timeout 2m30s \
		-f -
	sleep 60

uninstall-ingress-chart:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${RED_TEXT}helm uninstall${RESET}"
	helm uninstall ingress-basic --namespace $$INGRESS_NAMESPACE


# Hello World
# -----------

apply-hello:
	@echo ""
	@echo "${PURPLE} Hello World ${RESET} ${YELLOW_TEXT}kubectl apply -f manifests/hello-world/…${RESET}"
	@cat ./manifests/hello-world/secret-provider-class.yaml | envsubst | kubectl apply -f -
	@cat ./manifests/hello-world/deployment.yaml | envsubst | kubectl apply -f -
	@cat ./manifests/hello-world/ingress.yaml | envsubst | kubectl apply -f -
	@cat ./manifests/hello-world/service.yaml | envsubst | kubectl apply -f -

remove-hello:
	@echo ""
	@echo "${PURPLE} Hello World ${RESET} ${RED_TEXT}kubectl delete -f manifests/hello-world/…${RESET}"
	@cat ./manifests/hello-world/secret-provider-class.yaml | envsubst | kubectl delete -f -
	@cat ./manifests/hello-world/ingress.yaml | envsubst | kubectl delete -f -
	@cat ./manifests/hello-world/service.yaml | envsubst | kubectl delete -f -
	@cat ./manifests/hello-world/deployment.yaml | envsubst | kubectl delete -f -



# ============= #
# Misc. Scripts
# ============= #

get-web-app-routing-id:
	terraform output -json summary | jq -r ".managed_identities.web_app_routing[0].web_app_routing_identity[0].user_assigned_identity_id"