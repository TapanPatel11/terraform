
!!! abstract "What's ArgoCD?"
    **ArgoCD** is a declarative, GitOps continuous delivery tool for Kubernetes. This document outlines the infrastructure provisioning, architecture, and deployment details of ArgoCD hosted on an **AWS EKS cluster** using Terraform.

    To demonstrate my ability and understanding of Kubernetes infrastructure, I developed custom Terraform modules for **VPC** and **EKS cluster provisioning** instead of relying on pre-built modules. This approach allows for full control, flexibility, and a deeper grasp of the infrastructure. [Read more..](https://argo-cd.readthedocs.io)

!!! note "Why Custom Modules?"
    While there are ready-to-go Terraform modules available for AWS VPC and EKS, I chose to create my own modules to showcase my proficiency in **Terraform**, **Kubernetes**, and **AWS infrastructure**.

    Developing these custom modules enabled me to:
    - Gain greater control over resource configuration.
    - Demonstrate my ability to design scalable, secure, and modular infrastructure.
    - Troubleshoot effectively and understand the internals of AWS VPC and EKS.

---

## Features

???+ example "Why use ArgoCD on EKS?"

    - [x] **GitOps Workflow**  
      Automates application deployments using declarative Git-based workflows.
    - [x] **Highly Available Infrastructure**  
      Provisions an EKS cluster across multiple availability zones using a custom VPC.
    - [x] **Custom Terraform Modules**  
      Demonstrates expertise in writing reusable infrastructure modules.
    - [x] **Scalable Design**  
      Supports managed node groups with auto-scaling capabilities.
    - [x] **Secure Networking**  
      Implements secure VPC, private/public subnets, and NAT Gateways.
    - [x] **Add-ons Installation**  
      Integrates critical EKS add-ons such as:
        - **CoreDNS**
        - **AWS VPC CNI**
        - **Kube Proxy**
        - **EBS CSI Driver**

---

## ArgoCD Walkthrough

![ArgoCD UI](https://argo-cd.readthedocs.io/en/stable/assets/argocd-ui.gif){ align=left }

### **Custom EKS Deployment Demo**

To see the infrastructure in action, visit my Terraform repository showcasing the deployment of ArgoCD:  
   [**EKS Infrastructure Deployment**](https://github.com/TapanPatel11/terraform/tree/main/argocd)

### **ArgoCD UI**  

The ArgoCD admin UI is exposed securely via Load balancer, providing visibility into application synchronization and deployments.

---

## Architecture

!!! tip "Modular Infrastructure"
    The infrastructure follows a modular design with custom Terraform modules for:
    - **VPC**: To create the network topology (subnets, NAT Gateway, route tables, etc.).
    - **EKS**: To provision the Kubernetes cluster with managed node groups and add-ons.

---

!!! warning "Architecture Diagram"
    Coming soon...  

---

### **AWS Services Used**

| Service                  | Purpose                                         |
|--------------------------|-------------------------------------------------|
| **AWS VPC**              | Creates a secure, isolated network for EKS.     |
| **AWS Subnets**          | Divides network into public and private subnets. |
| **AWS NAT Gateway**      | Enables outbound internet access for private subnets. |
| **AWS EKS**              | Hosts the Kubernetes cluster for ArgoCD.       |
| **AWS IAM Roles**        | Provides access control for EKS nodes and services. |
| **AWS Security Groups**  | Controls inbound/outbound traffic for cluster security. |
| **Elastic Block Storage (EBS)** | Provides persistent storage for EKS workloads. |

---

## Deployment

### **Deployment Workflow**

1. **Clone the Repository**  
   Clone the Terraform repository containing the VPC and EKS custom modules:
   ```bash
   git clone https://github.com/tapanpatel11/terraform.git
   cd terraform
   ```

2. **Provision the VPC**  
   Navigate to the VPC module directory and apply the Terraform configuration:
   ```bash
   cd modules/vpc
   terraform init
   terraform apply
   ```

3. **Provision the EKS Cluster**  
   Navigate to the EKS module directory and apply the Terraform configuration:
   ```bash
   cd ../eks
   terraform init
   terraform apply
   ```

4. **Deploy ArgoCD on EKS**  
   Once the EKS cluster is ready, deploy ArgoCD using `kubectl`:
   ```bash
   kubectl create namespace argocd
   kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
   ```

5. **Access the ArgoCD UI**  
   Forward the ArgoCD UI port to your local machine:
   ```bash
   kubectl port-forward svc/argocd-server -n argocd 8080:443
   ```
   Access the UI at `https://localhost:8080` and log in using the default admin credentials.

---

## Prerequisites  

Ensure the following prerequisites are met before deploying the infrastructure:

- **AWS CLI**: Installed and configured with credentials.
- **Terraform**: Version `>= 1.6.1` installed.
- **kubectl**: Kubernetes CLI for managing EKS workloads.
- **IAM Permissions**: Permissions to create VPC, EKS, and related AWS resources.

---

## Security Features

This deployment implements AWS best practices for security:

- **VPC Isolation**: Resources are provisioned in private and public subnets for enhanced security.
- **IAM Roles and Policies**: Follows the principle of least privilege for access management.
- **Security Groups**: Restricts traffic to only trusted IP ranges and services.
- **Cluster Add-ons**: Includes AWS EBS CSI driver for secure persistent storage.
- **Admin Access**: ArgoCD UI access is secured via Kubernetes RBAC and port forwarding.

---

## Cost Analysis

### Upfront Costs
- **Terraform State Management**: Backend S3 bucket and DynamoDB table.
- **VPC and NAT Gateway**: Initial provisioning costs for network resources.
- **EKS Control Plane**: Standard AWS EKS control plane fees.

### Ongoing Costs
| Service                  | Cost Basis                                      |
|--------------------------|-------------------------------------------------|
| **EKS Control Plane**    | Fixed hourly fee for the Kubernetes control plane. |
| **NAT Gateway**          | Pay-per-GB for outbound traffic.                |
| **EKS Worker Nodes**     | Costs based on the EC2 instances (t3.medium).   |
| **Elastic Block Storage**| Costs for EBS volumes provisioned for workloads.|

---

## Next Steps

!!! warning "To Be Improved"
    - [x] Integrate ArgoCD with **GitHub** for automated sync.
    - [x] Deploy **Ingress Controller** for external access to workloads.
    - [x] Configure **OIDC Authentication** for ArgoCD UI.
    - [x] Implement **Monitoring** with Prometheus and Grafana.
    - [x] Enable auto-scaling for the EKS worker nodes.

---

## **Contact**

!!! question "Questions or Suggestions?"
    If you have any feedback, suggestions, or queries regarding this deployment, feel free to reach out. I'm always happy to share insights and learn more!

---