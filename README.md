<<<<<<< HEAD
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

=======
# 🚀 **DevOps Project: ZOMATO Clone App Deployment**

In this **DevOps project**, I demonstrate how to **deploy a ZOMATO Clone App** using a variety of modern DevOps tools and services.

## 🛠️ Tools & Services Used:

1. **GitHub** ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white)
2. **Jenkins** ![Jenkins](https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=jenkins&logoColor=white)
3. **SonarQube** ![SonarQube](https://img.shields.io/badge/SonarQube-4E9BCD?style=flat-square&logo=sonarqube&logoColor=white)
4. **Docker** ![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)
5. **Kubernetes** ![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=flat-square&logo=kubernetes&logoColor=white)
6. **Prometheus** ![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=flat-square&logo=prometheus&logoColor=white)
7. **Grafana** ![Grafana](https://img.shields.io/badge/Grafana-F46800?style=flat-square&logo=grafana&logoColor=white)
8. **ArgoCD** ![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=flat-square&logo=argo&logoColor=white)
9. **OWASP** ![OWASP](https://img.shields.io/badge/OWASP-000000?style=flat-square&logo=owasp&logoColor=white)
10. **Trivy** ![Trivy](https://img.shields.io/badge/Trivy-00979D?style=flat-square&logo=trivy&logoColor=white)

---

### Project Stages:

1. **Stage 1** - Deployment of App to Docker Container
2. **Stage 2** - Deployment of App to K8S Cluster with Monitoring

---

### 📂 GitHub Repo Link:  
[**ZOMATO Clone DevOps Project**](#)

### 📹 DevOps Project Video Link:  
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=youtube&logoColor=white)](https://youtu.be/GyoI6-I68aQ)

### 📺 Docker Playlist Video Link:  
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=youtube&logoColor=white)](https://www.youtube.com/playlist?list=PLs-PsDpuAuTeNx3OgGQ1QrpNBo-XE6VBh)

---

## 📂 Other DevOps Projects

### 🟠 **SWIGGY App Project**:  
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=youtube&logoColor=white)](https://youtu.be/x55z7rk0NAU)

### 🔵 **SonarQube Video Link**:  
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=sonarqube&logoColor=white)](https://youtu.be/ScdedztTaAU)

### 🟡 **Nexus Video Link**:  
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=flat-square&logo=nexus&logoColor=white)](https://youtu.be/opJAfDOCZuI)

---

## Connect with me on LinkedIn:  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/kastro-kiran/)

## Join the WhatsApp Group for DevOps technical discussions!
[![WhatsApp](https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](https://chat.whatsapp.com/EGw6ZlwUHZc82cA0vXFnwm) 

---

### Feedback Request:  

After deploying the app, please share your opinion on LinkedIn along with the Project link and tag me on LinkedIn. Help the video reach wider DevOps enthusiasts.

---

## Happy learning!  
<img src="https://media.licdn.com/dms/image/v2/D5603AQHJB_lF1d9OSw/profile-displayphoto-shrink_800_800/profile-displayphoto-shrink_800_800/0/1718971147172?e=1735776000&v=beta&t=HC_e0eOufPvf8XQ0P7iI9GDm9hBSIh5FwQaGsL_8ivo" alt="Kastro Profile Image" width="100" height="100" style="border-radius:50%;">

KASTRO KIRAN V
>>>>>>> 94acad9399cc0c677fc1ebf25f98e1b1973d2123

aws eks update-kubeconfig --name zomato-cluster --region us-east-1