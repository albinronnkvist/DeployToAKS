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
kubectl apply -f Source/Test/Services/Template/template-service.yaml
kubectl apply -f Source/Test/Services/Template/template-web.yaml
kubectl apply -f Source/Test/Services/Template/template-ingress.yaml
helm install template-web-nginx ingress-nginx/ingress-nginx --version 4.1.3 --set controller.ingressClassResource.name=template-web-nginx --set defaultController.replicaCount=2 --set rbac.create=true --set defaultController.nodeSelector."kubernetes.io/os"=linux --set controller.service.annotations."service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path"=/healthz -n ingress
