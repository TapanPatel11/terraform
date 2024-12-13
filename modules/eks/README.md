# AWS EKS Module

!!!abstract "What's this?"
    This module provides a way to create and manage an AWS Elastic Kubernetes Service (EKS) cluster and its associated resources using Terraform. The module is highly configurable, allowing you to define parameters like node group configuration, AMI type, capacity type, IAM roles, security groups, and more.

## Features

???+Example "Why use this?"
    - [x] Creation of an EKS cluster with customizable VPC, subnets, and security groups.
    - [x] Configurable managed node groups with flexible instance types and scaling.
    - [x] Integration with IAM roles and policies for fine-grained access control.
    - [x] Automatic installation of essential EKS add-ons like VPC CNI, Kube Proxy, CoreDNS, and more.
    - [x] Secure communication between worker nodes and the control plane using security groups.

---

## Requirements
???+warning "Pre-requisites"
    - [x] **Terraform version:** >= 1.6.1
    - [x] **AWS Provider:** >= 5.8.0

---

## Inputs

??? "Cluster Configuration"
    | Name                  | Description                                                       | Type   | Default         |
    |-----------------------|-------------------------------------------------------------------|--------|-----------------|
    | `cluster_name`         | Name of the EKS cluster.                                          | string | `test-cluster`  |
    | `vpc_name`             | Name of the VPC where the EKS cluster will be deployed.           | string | N/A             |
    | `default_ami_type`     | AMI type for the EKS node groups.                                  | string | `AL2_x86_64`    |
    | `default_capacity_type`| Capacity type for the node group (on-demand or spot).             | string | `ON_DEMAND`     |

??? "Node Group Configuration"
    | Name                     | Description                                                       | Type   | Default         |
    |--------------------------|-------------------------------------------------------------------|--------|-----------------|
    | `managed_node_groups`     | Map of managed node groups with configurations (e.g., name, size). | map    | See example     |
    | `ebs_volume_size`         | Size of the EBS volume for node instances (in GiB).               | number | `20`            |
    | `ebs_volume_type`         | Type of the EBS volume for node instances.                        | string | `gp2`           |

??? "Subnet Configuration"
    | Name                     | Description                                                       | Type   | Default         |
    |--------------------------|-------------------------------------------------------------------|--------|-----------------|
    | `private_subnet_ids`      | List of private subnet IDs for the cluster.                       | list   | `[]`            |
    | `public_subnet_ids`       | List of public subnet IDs for the cluster.                        | list   | `[]`            |

??? "Add-ons"
    | Name                     | Description                                                       | Type   | Default         |
    |--------------------------|-------------------------------------------------------------------|--------|-----------------|
    | `cluster_addons`          | Set of add-ons to install on the EKS cluster (e.g., VPC CNI, kube-proxy). | set    | See example     |

---

## Outputs

??? "Outputs"
    | Name                        | Description                                       |
    |-----------------------------|---------------------------------------------------|
    | `eks_cluster_id`             | The ID of the created EKS cluster.                |
    | `eks_cluster_endpoint`       | The endpoint URL of the EKS cluster.              |
    | `eks_cluster_security_group` | The security group ID for the EKS cluster.       |
    | `managed_node_group_ids`     | List of IDs for the managed node groups.          |
    | `iam_roles`                  | List of IAM roles associated with the cluster.    |

---

## Usage
```hcl
module "eks" {
  source = "./path-to-this-module"

  cluster_name          = "my-eks-cluster"
  vpc_name              = "my-vpc"
  default_ami_type      = "AL2_x86_64"
  default_capacity_type = "ON_DEMAND"

  managed_node_groups = {
    "node-group-1" = {
      name           = "node-group-1"
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
    }
  }

  ebs_volume_size    = 30
  ebs_volume_type    = "gp3"
  private_subnet_ids = ["subnet-abc123", "subnet-def456"]
  public_subnet_ids  = ["subnet-ghi789"]

  cluster_addons = [
    "vpc-cni",
    "kube-proxy",
    "coreDNS"
  ]
}
