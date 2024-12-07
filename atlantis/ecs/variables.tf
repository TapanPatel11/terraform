variable "env" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "atlantis"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

locals {
  tags = {
    env = "${var.env}"
  }
  subnet1_name        = "${var.app_name}-sb-first"
  subnet2_name        = "${var.app_name}-sb-second"
  subnet3_name        = "${var.app_name}-sb-third"
  target_group_name   = "${var.app_name}-alb-tg"
  security_group_name = "${var.app_name}-SG"
}

data "aws_subnet" "subnet1" {
  filter {
    name   = "tag:name"
    values = [local.subnet1_name]
  }
}
data "aws_subnet" "subnet2" {
  filter {
    name   = "tag:name"
    values = [local.subnet2_name]
  }
}
data "aws_subnet" "subnet3" {
  filter {
    name   = "tag:name"
    values = [local.subnet3_name]
  }
}

data "aws_lb_target_group" "tg" {
  name = local.target_group_name
}
data "aws_security_group" "sg" {
  name = local.security_group_name
}