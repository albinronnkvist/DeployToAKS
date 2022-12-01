# Upgrade a cluster
# Check if releases are available
az aks get-upgrades \
    --resource-group <name-of-resource-group> \
    --name <name-of-cluster>
# Upgrade
az aks upgrade \
    --resource-group <name-of-resource-group> \
    --name <name-of-cluster> \
    --kubernetes-version <KUBERNETES_VERSION>
# View the upgrade events
kubectl get events
# Validate an upgrade
az aks show \
    --resource-group <name-of-resource-group> \
    --name <name-of-cluster> \
    --output table

# Delete cluster (and all other resources in that group)
az group delete \
    --name <name-of-resource-group> \
    --yes \
    --no-wait