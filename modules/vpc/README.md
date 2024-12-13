# AWS VPC Module

!!!abstract "What's this?"
    This module provides a way to create and manage an AWS Virtual Private Cloud (VPC) and its associated resources using Terraform. The module is highly configurable, allowing you to define parameters like subnet configuration, NAT Gateway deployment, tagging, and more.

## Features

???+Example "Why use this?"
    - [x] Creation of a VPC with configurable CIDR block, DNS support, and DNS hostnames.
    - [x] Public and private subnets with configurable counts and sizes.
    - [x] Optional NAT Gateway deployment.
    - [x] Automatic tagging of resources.
    - [x] Internet Gateway and route tables for public and private subnets.

---

## Requirements
???+warning "Pre-requisites"
    - [x] **Terraform version:** >= 1.6.1
    - [x] **AWS Provider:** >= 5.8.0
---

## Inputs

??? "VPC Configuration"
    | Name                  | Description                                                     | Type   | Default         |
    |-----------------------|-----------------------------------------------------------------|--------|-----------------|
    | `region`              | Target AWS region.                                             | string | `us-east-1`     |
    | `cidr_block`          | The IPv4 CIDR block for the VPC.                              | string | `10.1.0.0/16`   |
    | `enable_dns_support`  | Enable/disable DNS support in the VPC.                        | bool   | `true`          |
    | `enable_dns_hostnames`| Enable/disable DNS hostnames in the VPC.                      | bool   | `false`         |

??? "Subnet Configuration"
    | Name                            | Description                                         | Type   | Default         |
    |---------------------------------|-----------------------------------------------------|--------|-----------------|
    | `public_subnet_count`           | Number of public subnets.                          | number | `3`             |
    | `public_subnet_additional_bits` | Additional bits for public subnet prefix.          | number | `4`             |
    | `private_subnet_count`          | Number of private subnets.                         | number | `3`             |
    | `private_subnet_additional_bits`| Additional bits for private subnet prefix.         | number | `4`             |

??? "Tagging"
    | Name             | Description                                         | Type         | Default                                     |
    |------------------|-----------------------------------------------------|--------------|---------------------------------------------|
    | `global_tags`    | Global tags applied to all resources.              | map(string)  | `{ManagedBy = "Terraform", Environment = "dev"}` |
    | `default_tags`   | Tags to add to all resources.                      | map(string)  | `{}`                                        |
    | `public_subnet_tags` | Tags to add to public subnets.                 | map(string)  | `{Tier:Public}`                                        |
    | `private_subnet_tags`| Tags to add to private subnets.                | map(string)  | `{Tier:Private}`                                        |

??? "NAT Gateway"
    | Name           | Description                           | Type  | Default |
    |----------------|---------------------------------------|-------|---------|
    | `nat_gateway`  | Flag to deploy a NAT Gateway.         | bool  | `false` |

??? "AWS Account"
    | Name                  | Description                       | Type   | Default |
    |-----------------------|-----------------------------------|--------|---------|
    | `aws_account_number`  | AWS account number used for deployment. | number | N/A     |

---

## Outputs

??? "Outputs"
    | Name                        | Description                                   |
    |-----------------------------|-----------------------------------------------|
    | `vpc_id`                    | The ID of the created VPC.                   |
    | `public_subnets`            | List of IDs of the public subnets.           |
    | `private_subnets`           | List of IDs of the private subnets.          |
    | `aws_internet_gateway`      | Details of the Internet Gateway.             |
    | `aws_route_table_public`    | The ID of the public route table.            |
    | `aws_route_table_private`   | The ID of the private route table.           |
    | `nat_gateway_ipv4_address`  | Public IP address of the NAT Gateway.         |

---

## Usage
```hcl
module "vpc" {
  source = "./path-to-this-module"

  region                   = "us-west-2"
  aws_account_number       = 123456789012
  vpc_name                 = "my-vpc"
  cidr_block               = "10.0.0.0/16"
  enable_dns_support       = true
  enable_dns_hostnames     = true

  public_subnet_count      = 2
  private_subnet_count     = 2

  nat_gateway              = true

  global_tags = {
    Project     = "my-project"
    Environment = "production"
  }
}
```

---

## Resources Created
- VPC
- Subnets (public and private)
- Internet Gateway
- NAT Gateway (optional)
- Elastic IP for NAT Gateway
- Route tables (public and private) and route associations
- Default security group

---
## **Contact**

!!!question "Any doubts?"
    Feel free to reach out if you have any suggestions, doubt's or wish to know more! Thanks!

---