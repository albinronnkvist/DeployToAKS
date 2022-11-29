###
# Create cluster
###
# Create resource group
az group create --name Kubernetes-T --location westeurope

# Create AKS cluster
az aks create \
    -g Kubernetes-T \
    -n adronl-t1 \
    --enable-managed-identity \
    --node-count 1 \
    --enable-addons monitoring \
    --enable-msi-auth-for-monitoring \
    --generate-ssh-keys

# Install Kubectl locally
az aks install-cli

# Connect to cluster
az aks get-credentials \
    --resource-group Kubernetes-T \
    --name adronl-t1

# (Optional) Verify the connection to your cluster
kubectl get nodes



####
# Create non-environment specifc namespaces
####
kubectl apply -f Source/Shared/ingress-namespace.yaml



####
# Cert-manager
####
# Install the CustomResourceDefinition resources
kubectl apply --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v0.15.1/cert-manager.yaml

# Add the Jetstack Helm repository and update your local Helm chart repo cache
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
helm install --name cert-manager \
    -n ingress \
    --version v0.15.0 jetstack\cert-manager

# (Optional) Verify the installation
kubectl get pods -n ingress

# Apply ClusterIssuer (used in all namespaces)
kubectl apply -f Source/Shared/letsencrypt-clusterissuer.yaml

# (Optional) List cluster-issuers
kubectl get clusterissuers