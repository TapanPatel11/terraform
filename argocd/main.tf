provider "aws" {
  region = "us-east-1"
}



module "argocd-vpc" {
  source = "../modules/vpc"//"github.com/TapanPatel11/terraform//modules/vpc"
  region                   = var.region
  aws_account_number       = var.aws_account_number
  vpc_name                 = var.vpc_name   
  cidr_block               = var.cidr_block
  enable_dns_support       = var.enable_dns_support
  enable_dns_hostnames     = var.enable_dns_hostnames

  public_subnet_count      = var.public_subnet_count
  private_subnet_count     = var.private_subnet_count

  nat_gateway              = var.nat_gateway

  global_tags = {
    Project     = "argocd-project"
    Environment = "dev"
  }
  }



module "argocd-eks" {
  source = "../modules/eks"//"github.com/TapanPatel11/terraform//modules/eks"
cluster_name          = "argocd-eks-cluster"
  vpc_name              = var.vpc_name   
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
  ebs_volume_type    = "gp2"
  private_subnet_ids = data.aws_subnets.private_subnets.ids
  public_subnet_ids  = data.aws_subnets.public_subnets.ids

  cluster_addons = [
    "aws-ebs-csi-driver",
    "vpc-cni",
    "kube-proxy",
    "coredns"
    
  ]
  }

  
  data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]  
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Tier = "Private"
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = {
    Tier = "Public"
  }
}
output "va" {
  value = data.aws_subnets.private_subnets.ids
}
output "va2" {
  value = data.aws_subnets.public_subnets.ids
}
output "va3" {
  value = data.aws_vpc.vpc.id
}