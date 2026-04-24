# Zero Trust Microservices Architecture on Azure

A fully deployed Zero Trust security architecture built on Azure Kubernetes Service for ITS 4900 Cloud Architecture.

## Architecture Overview

```
User → Azure API Management → Azure AD → AKS Cluster
                                         ├── Frontend Service
                                         ├── Orders Service
                                         └── Products Service
                                              ↓
                                         Key Vault (private endpoint)
                                              ↓
                                         Grafana + Prometheus + Loki
                                         (protected by Azure AD SSO)
```

## Zero Trust Principles Applied

**Verify Explicitly**
- Azure AD verifies every request from users and services
- Workload Identity federation — no passwords anywhere
- Managed Identities for all service-to-Azure communication

**Least Privilege**
- Network Policies enforce explicit allow-only traffic rules
- Each service has its own identity with access only to its own secrets
- Key Vault RBAC restricts secret access per service

**Assume Breach**
- Linkerd service mesh enforces mTLS between all services
- All traffic inside the cluster is encrypted and mutually authenticated
- Full audit trail in Grafana via Prometheus and Loki
- Grafana protected behind Azure AD SSO

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Cluster | Azure Kubernetes Service |
| Entry Point | Azure API Management (Consumption) |
| Identity | Azure AD + Workload Identity |
| Secrets | Azure Key Vault |
| Service Mesh | Linkerd mTLS |
| Network Security | Kubernetes Network Policies |
| Container Registry | Azure Container Registry |
| Observability | Grafana + Prometheus + Loki |
| IaC | OpenTofu + Ansible |

## Project Structure

```
zero-trust-aks/
├── infrastructure/
│   └── tofu/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
│       └── modules/
│           ├── aks/
│           ├── acr/
│           ├── networking/
│           ├── keyvault/
│           └── apim/
├── kubernetes/
│   ├── manifests/
│   │   ├── frontend.yaml
│   │   ├── orders.yaml
│   │   ├── products.yaml
│   │   ├── network-policies.yaml
│   │   ├── service-accounts.yaml
│   │   └── secret-provider.yaml
│   └── helm/
│       └── grafana-values.yaml
├── apps/
│   ├── frontend/
│   ├── orders/
│   └── products/
└── docs/
```

## Deployment

### Prerequisites
- Azure CLI
- OpenTofu
- kubectl
- Helm
- Linkerd CLI
- Docker

### Deploy Infrastructure

```bash
cd infrastructure/tofu
az login
tofu init
tofu apply
```

### Connect to Cluster

```bash
az aks get-credentials --resource-group zero-trust-rg --name zero-trust-aks
```

### Install Linkerd

```bash
export PATH=$HOME/.linkerd2/bin:$PATH
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.0/standard-install.yaml
linkerd install --crds | kubectl apply -f -
linkerd install | kubectl apply -f -
linkerd check
```

### Install CSI Driver

```bash
helm repo add csi-secrets-store-provider-azure https://azure.github.io/secrets-store-csi-driver-provider-azure/charts
helm repo update
helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure \
  --generate-name \
  --namespace kube-system \
  --set secrets-store-csi-driver.syncSecret.enabled=true
```

### Deploy Applications

```bash
kubectl annotate namespace default linkerd.io/inject=enabled
cd kubernetes/manifests
kubectl apply -f service-accounts.yaml
kubectl apply -f secret-provider.yaml
kubectl apply -f products.yaml
kubectl apply -f orders.yaml
kubectl apply -f frontend.yaml
kubectl apply -f network-policies.yaml
```

### Deploy Observability Stack

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl create namespace monitoring

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set grafana.enabled=false \
  --set prometheusOperator.admissionWebhooks.enabled=false \
  --set prometheusOperator.admissionWebhooks.patch.enabled=false \
  --set prometheusOperator.tls.enabled=false

helm install loki grafana/loki-stack \
  --namespace monitoring \
  --set grafana.enabled=false \
  --set prometheus.enabled=false

helm install grafana grafana/grafana \
  --namespace monitoring \
  --values kubernetes/helm/grafana-values.yaml
```

### Tear Down

```bash
cd infrastructure/tofu
tofu destroy
```

## Cost Management

This project is designed for Azure student subscriptions. Always run `tofu destroy` when not actively working to avoid unnecessary charges. Estimated cost for a full session is $1-2/hour.
