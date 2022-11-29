####
# Create namespace
####
kubectl apply -f Source/Test/test-namespace.yaml



###
# Apply shared config and rules
###
kubectl apply -f Source/Test/Shared/shared-configmap.yaml
kubectl apply -f Source/Test/Shared/shared-secret.yaml
kubectl apply -f Source/Test/Shared/shared-resourcequota.yaml
kubectl apply -f Source/Test/Shared/shared-limitrange.yaml



###
# Deploy Microservice
###
# Microservice with: Deployment, Service & Ingress
# We also need to install Ingress Nginx Controller
kubectl apply -f Source/Test/microservice-template-web.yaml
helm install corniche-events-relay-nginx ingress-nginx/ingress-nginx \
    --version 4.0.19 \
    --set controller.ingressClassResource.name=corniche-events-relay-nginx 
    --set defaultController.replicaCount=2 \
    --set rbac.create=true 
    --set defaultController.nodeSelector."kubernetes.io/os"=linux \
    --set controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path"=/healthz \
    -n ingress
