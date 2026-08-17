# AWS EKS & Jenkins CI/CD Pipeline (Tech Challenge 2)

## Overview
This repository contains an end-to-end DevOps pipeline that provisions AWS infrastructure using Terraform, deploys a Kubernetes cluster (EKS v1.31), builds and pushes a containerized application to AWS ECR, and executes continuous deployment via a Jenkins CI/CD pipeline managed with Helm.

---

## Project Execution Across All 6 Phases

### Phase 1: Local Application & Dockerization
* Developed a simple Node.js "Hello World" application.
* Containerized the application using a lightweight multi-stage `Dockerfile`.
* Built and tested the container image locally to verify runtime port exposure and functionality.

### Phase 2: Infrastructure as Code (Terraform)
* **VPC Module**: Provisioned a multi-AZ VPC with dedicated public and private subnets, NAT Gateways, and route tables.
* **EKS Cluster Module**: Configured `tech-challenge-eks` (v1.31) using standard Terraform AWS modules.
  * Auto-scaling node group set to `t3.small` instances (Min: 1, Max: 4, Desired: 1).
* **Jenkins EC2 Instance**: Provisioned an EC2 instance with an IAM Role (`jenkins-server-role`) for ECR/EKS permissions.

### Phase 3: Cluster Authentication & RBAC Access
* Configured AWS EKS **Access Entries** directly in Terraform.
* Mapped the `jenkins-server-role` IAM principal to the `AmazonEKSClusterAdminPolicy` with cluster-wide scope.
* Validated security group ingress/egress rules for public cluster endpoint connectivity.

### Phase 4: Container Registry (ECR) Integration
* Created a private AWS ECR repository (`tech-challenge-app`).
* Configured automated Docker authentication in Jenkins using AWS CLI credentials and temporary ECR authorization tokens.

### Phase 5: CI/CD Pipeline Automation (`Jenkinsfile`)
* **Checkout**: Fetches source code directly from GitHub.
* **Build & Tag**: Compiles application and builds Docker image tagged with build ID.
* **ECR Push**: Authenticates and pushes container image to AWS ECR.
* **EKS Deploy**: Updates local `kubeconfig` (`aws eks update-kubeconfig`) and executes `helm upgrade --install` to deploy/update application pods.

### Phase 6: Validation & Documentation
* Verified running pods (`kubectl get pods`) and LoadBalancer service health (`kubectl get svc`).
* confirmed successful HTTP response (`Hello, World!`) via AWS Classic LoadBalancer.
* Validated tear-down procedures via `terraform destroy`.

---

## Live Endpoint
- **LoadBalancer URL**: `http:Your URL'
