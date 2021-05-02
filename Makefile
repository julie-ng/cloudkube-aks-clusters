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
INGRESS_MI_NAME=$(shell terraform output -json summary | jq -r .aks_cluster.ingress_mi.name)
INGRESS_MI_CLIENT_ID=$(shell terraform output -json summary | jq -r .aks_cluster.ingress_mi.client_id)
INGRESS_MI_RESOURCE_ID=$(shell terraform output -json summary | jq -r .aks_cluster.ingress_mi.id)
INGRESS_PUBLIC_IP=$(shell terraform output -json summary | jq -r .aks_cluster.public_ip)
CLUSTER_KV_NAME=$(shell terraform output -json summary | jq -r .key_vault.name)
POD_IDENTITY_CHART_VERSION=4.0.0


# ========= #
#  Scripts  #
# ========= #

# Get AKS Credentials

kubecontext:
	@echo "${PURPLE} Kubernetes ${RESET} Set Kubernetes context"
	az aks get-credentials \
		--resource-group ${AKS_RG_NAME} \
		--name ${AKS_CLUSTER_NAME}
	kubectl get pods --all-namespaces


# All the commands
# ----------------

setup: create-namespaces install-azure-csi install-pod-identity install-ingress
uninstall: uninstall-ingress uninstall-pod-identity uninstall-azure-csi delete-namespaces


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

install-azure-csi:
	@echo ""
	@echo "${BLUE} Azure CSI ${RESET} ${YELLOW_TEXT}helm install${RESET}"
	helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts
	helm install azure-csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure \
		--namespace azure-csi

uninstall-azure-csi:
	@echo ""
	@echo "${BLUE} Azure CSI ${RESET} ${RED_TEXT}helm uninstall${RESET}"
	helm uninstall azure-csi -n azure-csi

# Pod Identity
# ------------

install-pod-identity:
	@echo ""
	@echo "${BLUE} Pod Identity ${RESET} ${YELLOW_TEXT}helm install${RESET}"
	@echo ""
	helm repo add aad-pod-identity https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts
	helm upgrade aad-pod-identity aad-pod-identity/aad-pod-identity \
		--namespace azure-pod-identity \
		--version $$POD_IDENTITY_CHART_VERSION \
		--install
	@echo ""
	@echo "${BLUE} Pod Identity ${RESET} verify installation"
	@echo ""
	kubectl get pods -l "app.kubernetes.io/component=mic" -n azure-pod-identity
	@echo ""
	kubectl get pods -l "app.kubernetes.io/component=nmi" -n azure-pod-identity

uninstall-pod-identity:
	@echo ""
	@echo "${BLUE} Pod Identity ${RESET} ${RED_TEXT}helm uninstall${RESET}"
	@echo ""
	helm uninstall aad-pod-identity -n azure-pod-identity

# Ingress Controller
# ------------------

install-ingress: apply-ingress-mi-tls install-ingress-chart  apply-hello
uninstall-ingress: remove-hello remove-ingress-mi-tls uninstall-ingress-chart

install-ingress-chart:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${YELLOW_TEXT}helm install${RESET}"
	helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
	cat ./helm/ingress.values.yaml | envsubst | helm install ingress-basic ingress-nginx/ingress-nginx \
		--namespace ingress \
		--timeout 2m30s \
		-f -

update-ingress-chart:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${YELLOW_TEXT}helm upgrade${RESET}"
	cat ./helm/ingress.values.yaml | envsubst | helm upgrade ingress-basic ingress-nginx/ingress-nginx \
		--namespace ingress \
		--timeout 2m30s \
		-f -

uninstall-ingress-chart:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${RED_TEXT}helm uninstall${RESET}"
	helm uninstall ingress-basic -n ingress

# Setup Bindings
# --------------

apply-ingress-mi-tls:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${YELLOW_TEXT}kubectl apply -f manifests/ingress/…${RESET}"
	@cat ./manifests/ingress/pod-identity.yaml | envsubst | kubectl apply -f -
	@cat ./manifests/ingress/secret-provider-classes.yaml | envsubst | kubectl apply -f -

remove-ingress-mi-tls:
	@echo ""
	@echo "${PURPLE} Ingress ${RESET} ${RED_TEXT}kubectl delete -f manifests/ingress/…${RESET}"
	@cat ./manifests/ingress/pod-identity.yaml | envsubst | kubectl delete -f -
	@cat ./manifests/ingress/secret-provider-classes.yaml | envsubst | kubectl delete -f -


# Hello World
# -----------

apply-hello:
	@echo ""
	@echo "${PURPLE} Hello World ${RESET} ${YELLOW_TEXT}kubectl apply -f manifests/hello-world/…${RESET}"
	@cat ./manifests/hello-world/deployment.yaml | envsubst | kubectl apply -f -
	@cat ./manifests/hello-world/ingress.yaml | envsubst | kubectl apply -f -
	@cat ./manifests/hello-world/service.yaml | envsubst | kubectl apply -f -

remove-hello:
	@echo ""
	@echo "${PURPLE} Hello World ${RESET} ${RED_TEXT}kubectl delete -f manifests/hello-world/…${RESET}"
	@cat ./manifests/hello-world/ingress.yaml | envsubst | kubectl delete -f -
	@cat ./manifests/hello-world/service.yaml | envsubst | kubectl delete -f -
	@cat ./manifests/hello-world/deployment.yaml | envsubst | kubectl delete -f -

# Debugging
# ---------

list-cluster-identities:
	@echo ""
	@echo "${YELLOW} Debugging ${RESET} List Cluster Identities"
	az identity list -g $$AKS_RG_NAME

list-node-identities:
	@echo ""
	@echo "${YELLOW} Debugging ${RESET} List AKS Node Identities"
	az identity list -g $$AKS_NODE_RG_NAME
