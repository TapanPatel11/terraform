# Variable for AWS region
variable "region" {
  description = "The AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

# Variable for AWS account number
variable "aws_account_number" {
  description = "The AWS account number"
  type        = number
}

# Variable for VPC name
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "argocd-vpc"
}

# Variable for CIDR block for the VPC
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.2.0.0/16"
}

# Variable for enabling DNS support in the VPC
variable "enable_dns_support" {
  description = "Whether DNS support is enabled in the VPC"
  type        = bool
  default     = true
}

# Variable for enabling DNS hostnames in the VPC
variable "enable_dns_hostnames" {
  description = "Whether DNS hostnames are enabled in the VPC"
  type        = bool
  default     = true
}

# Variable for the number of public subnets
variable "public_subnet_count" {
  description = "The number of public subnets to create in the VPC"
  type        = number
  default     = 2
}

# Variable for the number of private subnets
variable "private_subnet_count" {
  description = "The number of private subnets to create in the VPC"
  type        = number
  default     = 2
}

# Variable for enabling NAT Gateway
variable "nat_gateway" {
  description = "Whether to create a NAT Gateway for the VPC"
  type        = bool
  default     = true
}

