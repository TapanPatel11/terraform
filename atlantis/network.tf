provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "atlantis" {
  cidr_block = local.vpc_cidr
  tags = {
    name = "${var.app_name}-VPC"
  }
}

resource "aws_subnet" "first" {
  vpc_id     = aws_vpc.atlantis.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    name = "${var.app_name}-sb-first"
  }
}
resource "aws_subnet" "second" {
  vpc_id     = aws_vpc.atlantis.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    name = "${var.app_name}-sb-second"
  }
}
resource "aws_subnet" "third" {
  vpc_id     = aws_vpc.atlantis.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    name = "${var.app_name}-sb-third"
  }
}

resource "aws_internet_gateway" "atlantis" {
  vpc_id = aws_vpc.atlantis.id

  tags = {
    name = "${var.app_name}-IGW"
  }
}

resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.atlantis.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.atlantis.id
  }

  tags = {
    name = "${var.app_name}-VPC-RT"
  }
}

