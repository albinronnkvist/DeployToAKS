###
# RBAC
###
# Specify subscription by name
az account set --subscription "Adrava - Test/Stage"

# Create an Azure AD group (and copy the id for later use)
az ad group create --display-name AksAdmins --mail-nickname aks-admins
# b0be2f65-f86b-4668-8eaa-b22e1f3d9496

# Add a member to the group
az ad group member add --group AksAdmins --member-id 0c65442c-e207-4c71-abf1-a411f596c80f



###
# Create cluster
###
# Create resource group
az group create --name Kubernetes-T --location westeurope

# Create AKS cluster (this will take a while)
# replace <id> with the object ID of your Azure AD group
az aks create \
    -g Kubernetes-T \
    -n adronl-t1 \
    --enable-aad \
    --aad-admin-group-object-ids b0be2f65-f86b-4668-8eaa-b22e1f3d9496 \
    --aad-tenant-id b0be2f65-f86b-4668-8eaa-b22e1f3d9496 \
    --node-count 1 \
    #--enable-addons monitoring \
    --generate-ssh-keys

# Install Kubectl locally
az aks install-cli

# Connect to cluster
az aks get-credentials --resource-group Kubernetes-T --name adronl-t1 --admin

# (Optional) Verify the connection to your cluster
kubectl get nodes



####
# Create non-environment specific namespaces
####
kubectl apply -f Source/Shared/ingress-namespace.yaml



####
# Cert-manager
####
# Install the CustomResourceDefinition resources
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.1/cert-manager.crds.yaml

# Add the Jetstack Helm repository and update your local Helm chart repo cache
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Install the cert-manager Helm chart
helm template cert-manager jetstack/cert-manager --namespace ingress | kubectl apply -f -

# (Optional) Verify the installation
kubectl get pods -n ingress

# Apply ClusterIssuer (used in all namespaces)
kubectl apply -f Source/Shared/letsencrypt-clusterissuer.yaml

# (Optional) List cluster-issuers
kubectl get clusterissuers



###
# Nginx Ingress Controller
###
# Install 
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update