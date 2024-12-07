variable "env" {
  type = string
  default = "dev"
}

variable "app_name" {
  type = string
  default = "atlantis"
}

variable "region" {
  type = string
  default = "us-east-1"
}

locals {
  tags = {
    env = "${var.env}"
  }
  vpc_cidr = "10.0.0.0/16"

}