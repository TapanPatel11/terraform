variable "cluster_name" {
  type        = string
  default     = "test-cluster"
  description = "Name of the EKS cluster"
}
variable "vpc_name" {
  type        = string
  nullable    = false
  description = "Name of the VPC. No default value."
}



# Variable for the default AMI type for node groups
variable "default_ami_type" {
  description = "The AMI type to use for the node group"
  type        = string
  default     = "AL2_x86_64"
}

# Variable for the default capacity type (on-demand or spot)
variable "default_capacity_type" {
  description = "The capacity type to use for the node group"
  type        = string
  default     = "ON_DEMAND"
}

# Variable for managed node groups configuration (Map of node group attributes)
variable "managed_node_groups" {
  description = "Map of managed node groups configuration"
  type = map(object({
    name           = string
    desired_size   = number
    max_size       = number
    min_size       = number
    instance_types = list(string)
  }))
  default = {
    "node-group-1" = {
      name           = "node-group-1"
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t2.micro"]
    }
  }
}

# Variable for EBS volume size (in GiB)
variable "ebs_volume_size" {
  description = "The size of the EBS volume attached to the node group instances"
  type        = number
  default     = 20
}

# Variable for EBS volume type
variable "ebs_volume_type" {
  description = "The type of the EBS volume attached to the node group instances"
  type        = string
  default     = "gp2"
}

# Variable for the cluster add-ons (List or Set of add-on names)
variable "cluster_addons" {
  description = "List or Set of add-ons to be installed in the EKS cluster"
  type        = set(string) # Using set to ensure unique values
  default = [
    "vpc-cni",
    "kube-proxy",
    "aws-ebs-csi-driver",
    "coredns"
  ]
}
# Variable for private subnet IDs
variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = [] # Default is an empty list, modify based on your actual subnet IDs
}

# Variable for public subnet IDs
variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = [] # Default is an empty list, modify based on your actual subnet IDs
}
