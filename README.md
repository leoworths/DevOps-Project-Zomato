DevSecOps Project 
This project implements a full DevSecOps pipeline based on GitOps principles. With this pipeline, all infrastructure and application deployment configurations are stored as code, enabling automated provisioning and continuous deployment from a Git repository. The pipeline ensures security at every stage (from code to infrastructure) and provides real-time observability through integrated monitoring.

AWS: Provision EC2 instances, EKS, ECR, S3 bucket and IAM Policies and Roles
Terraform: Infrastructure as Code (IaC) to automate the provisioning of resources.
S3 Bucket: Remote storage for Terraform state files, ensuring the infrastructure state is shared across environments.
Jenkins : for Continuous Integration (CI) for building, testing, and pushing Docker images to ECR
ECR (Elastic Container Registry): Docker image registry provisioned with Terraform for secure image storage.
EKS (Elastic Kubernetes Service): Kubernetes orchestration and container management.
ArgoCD: for Continuous Deployment (CD) for GitOps-driven deployments of Kubernetes applications.
Helm: Package manager for Kubernetes applications, used to install Prometheus and Grafana.
Prometheus: Monitoring and alerting system for tracking the health of applications and infrastructure.
Grafana: Visualization tool for monitoring metrics and logs.
Continuous Deployment with ArgoCD

ArgoCD was used for Continuous Deployment following the GitOps model. It watches the Git repository for changes to Kubernetes manifests and automatically syncs those changes to the EKS cluster. In case of issues, ArgoCD enables quick rollback to the previous stable state

Security Best Practices

The pipeline integrates various security best practices at each stage:

Static Code Analysis: The Jenkins pipeline ran security scans on the source code with sonarQube to check for vulnerabilities and code smells, OWASP Dependencies Check and Quality Gate Analysis.

Dynamic Application Scanning: Performed vulnerability scanning on Docker images with Trivy tool.

AWS Secrets Manager used to securely manage secrets of credentials and API keys.

Kubernetes Security: Network Policies and RBAC (Role-Based Access Control) was used to enforce least-privilege access within Kubernetes and IAM policies and Roles.
# Zomato-Clone-Project

## Overview

This project is a clone of the Zomato website built using modern web technologies. It includes a frontend built with React and a backend built with Node.js and Express.js. The project also includes a database built with MongoDB and a deployment pipeline built with Jenkins.

## Technologies Used

- React
- Node.js
- Express.js
- MongoDB
- Jenkins
- AWS EKS
- AWS IAM
- AWS Secrets Manager
- AWS S3
- AWS CloudFront
- AWS RDS
- AWS CloudWatch
- AWS CodeCommit
- AWS CodeBuild
- AWS CodePipeline
- AWS CodeDeploy
- AWS ECR
- AWS ECS
- AWS ELB
- AWS ALB
- AWS ACM
- AWS WAF
- AWS CloudTrail
- AWS CloudFormation
- AWS CloudWatch Logs
- AWS CloudWatch Metrics
- AWS CloudWatch Alarms
- AWS CloudWatch Events


monitoring setup
#!/bin/bash

# Configure AWS and set up kubeconfig for the cluster
aws eks update-kubeconfig --name zomato-cluster --region us-east-1
# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Change ArgoCD service to LoadBalancer
kubectl patch svc argocd-server -n argocd -p '{"spec":{"type":"LoadBalancer"}}'

# Retrieve ArgoCD admin password
echo "ArgoCD Admin Password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo

# Retrieve ArgoCD URL
echo "ArgoCD URL:"
kubectl get svc -n argocd argocd-server -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" && echo

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add argoproj https://argoproj.github.io/argo-helm
helm repo update

# Install Prometheus and Grafana using Helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Deploy Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack -n argocd --create-namespace

# Retrieve Prometheus URL
echo "Prometheus URL:"
kubectl get svc -n argocd prometheus-kube-prometheus-stack-prometheus -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" && echo

# Install Grafana
helm install grafana grafana/grafana -n argocd

<<<<<<< HEAD
# Retrieve Grafana URL
echo "Grafana URL:"
kubectl get svc -n argocd grafana -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" && echo

# Retrieve Grafana admin password
echo "Grafana Admin Password:"
kubectl -n argocd get secret grafana -o jsonpath="{.data.admin-password}" | base64 --decode && echo

# Install Node Exporter
kubectl apply -f https://raw.githubusercontent.com/prometheus/node_exporter/master/manifests/node-exporter.yaml

#command
#vi setup.sh
#chmod +x setup.sh
#./setup.sh


Add Jenkins as a Target in Prometheus
Edit the kube-prometheus-stack configuration:

kubectl edit configmap prometheus-server -n argocd

Add a scrape job for Jenkins:
scrape_configs:
  - job_name: "jenkins"
    metrics_path: '/prometheus'
    static_configs:
      - targets: ["<JENKINS-SERVICE-URL>:8080"]


#apply the changes
kubectl apply -f prometheus-configmap.yaml

#Reload the Prometheus configuration
kubectl rollout restart deployment prometheus-server -n argocd

3. Expose Jenkins Metrics
The Prometheus plugin provides metrics at an endpoint (e.g., /prometheus). Configure the plugin to enable the endpoint:

Go to Manage Jenkins > Configure System.
Look for Prometheus Plugin settings.
Enable the endpoint and specify the port (default is 8080)
=======


aws eks update-kubeconfig --name zomato-cluster --region us-east-1