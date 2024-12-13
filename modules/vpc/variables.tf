variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Target AWS region. Default: us-east-1"
}

variable "aws_account_number" {
  type        = number
  description = "AWS account number used for deployment. No default value."
}

variable "global_tags" {
  type = map(string)
  default = {
    "ManagedBy"   = "Terraform"
    "Environment" = "dev"
  }
  description = "Global tags applied to all resources. Default: {ManagedBy = \"Terraform\", Environment = \"dev\"}"
}

variable "nat_gateway" {
  type        = bool
  default     = false
  description = "Flag to deploy NAT Gateway. Default: false"
}

variable "vpc_name" {
  type        = string
  nullable    = false
  description = "Name of the VPC. No default value."
}

variable "cidr_block" {
  type        = string
  default     = "10.1.0.0/16"
  description = "The IPv4 CIDR block for the VPC. Default: 10.1.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Flag to enable/disable DNS support in the VPC. Default: true"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = false
  description = "Flag to enable/disable DNS hostnames in the VPC. Default: false"
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Tags to add to all resources. Default: {} (empty map)"
}

variable "public_subnet_count" {
  type        = number
  default     = 3
  description = "Number of public subnets. Default: 3"
}

variable "public_subnet_additional_bits" {
  type        = number
  default     = 4
  description = "Number of additional bits for public subnet prefix. Default: 4"
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {
    "Tier":"Public"
  }
  description = "Tags to add to all public subnets.  Default: { Tier:Public}"
}

variable "private_subnet_count" {
  type        = number
  default     = 3
  description = "Number of private subnets. Default: 3"
}

variable "private_subnet_additional_bits" {
  type        = number
  default     = 4
  description = "Number of additional bits for private subnet prefix. Default: 4"
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {
        "Tier":"Private"
  }
  description = "Tags to add to all private subnets. Default: { Tier:Private} "
}
