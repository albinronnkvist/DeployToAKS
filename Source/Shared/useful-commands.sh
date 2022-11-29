# Manually scale Pods
kubectl scale --replicas=5 deployment/microservice-template-web-deployment

# Auto scale pods
kubectl autoscale deployment microservice-template-web-deployment --cpu-percent=50 --min=3 --max=10
# Or
kubectl apply -f microservice-template-web-autoscaling.yaml

# Manually scale AKS nodes
az aks scale --resource-group Kubernetes-T --name adronl-t1 --node-count 3

# Upgrade a cluster
# Check if releases are available
az aks get-upgrades \
    --resource-group Kubernetes-T \
    --name adronl-t1
# Upgrade
az aks upgrade \
    --resource-group Kubernetes-T \
    --name adronl-t1 \
    --kubernetes-version <KUBERNETES_VERSION>
# View the upgrade events
kubectl get events
# Validate an upgrade
az aks show \
    --resource-group Kubernetes-T \
    --name adronl-t1 \
    --output table

# Delete cluster (and all other resources in that group)
az group delete \
    --name Kubernetes-T \
    --yes \
    --no-wait