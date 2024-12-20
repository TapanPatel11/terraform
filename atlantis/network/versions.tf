terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.80.0"
    }
    github = {
      source = "integrations/github"
      version = "6.4.0"
    }
  }

  backend "s3" {
    bucket         = "atlantis-tf-state-dev"
    dynamodb_table = "atlantis-terraform-state-dev"
    key            = "terraform/atlantis-network.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}