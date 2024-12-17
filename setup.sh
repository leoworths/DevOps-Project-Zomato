#!/bin/bash
aws configure
# Configure AWS and set up kubeconfig for the cluster
aws eks update-kubeconfig --name zomato-cluster --region us-east-1

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Add Helm Repositories
helm repo add argoproj https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

#Deploy ArgoCD
kubectl create namespace argocd || true  # Ignore if namespace already exists
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose ArgoCD Server Service as LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"LoadBalancer"}}'

#kubectl create namespace monitoring

# install Prometheus Stack
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring --create-namespace

# Expose Prometheus Service as LoadBalancer
kubectl patch svc prometheus-kube-prometheus-prometheus -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'


# Deploy Grafana
kubectl patch svc prometheus-grafana -n monitoring -p '{"spec":{"type":"LoadBalancer"}}'



#Retrieve Prometheus URL
prometheus_url=$(kubectl get svc prometheus-kube-prometheus-prometheus -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Prometheus URL: http://$prometheus_url:9090"


#Retrieve Grafana URL and Admin Password
grafana_url=$(kubectl get svc prometheus-grafana -n monitoring -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Grafana URL: http://$grafana_url"

grafana_password=$(kubectl get secret -n monitoring prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Grafana Admin Password: $grafana_password"

#Retrieve ArgoCD URL and Admin Password

argocd_url=$(kubectl get svc -n argocd argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "ArgoCD URL: http://$argocd_url"

argocd_password=$(kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode)
echo "ArgoCD Admin Password: $argocd_password"

# Final Output
echo "----------------------------------------------------------"
echo "Setup completed successfully!"
echo "Prometheus URL: http://$prometheus_url"
echo "Grafana URL: http://$grafana_url"
echo "Grafana Admin Password: $grafana_password"
echo "ArgoCD URL: http://$argocd_url"
echo "ArgoCD Admin Password: $argocd_password"
echo "----------------------------------------------------------"

#command
#vi setup.sh
#chmod a+x setup.sh
#./setup.sh