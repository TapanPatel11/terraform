provider "aws" {
  region = "us-east-1"
}

# Create the VPC resource
resource "aws_vpc" "atlantis" {
  cidr_block = local.vpc_cidr
  tags = {
    name = "${var.app_name}-VPC"
  }
}

# Create Subnet 1 in availability zone 'us-east-1a'
resource "aws_subnet" "first" {
  vpc_id            = aws_vpc.atlantis.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    name = "${var.app_name}-sb-first"
  }
}

# Create Subnet 2 in availability zone 'us-east-1b'
resource "aws_subnet" "second" {
  vpc_id            = aws_vpc.atlantis.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    name = "${var.app_name}-sb-second"
  }
}

# Create Subnet 3 in availability zone 'us-east-1c'
resource "aws_subnet" "third" {
  vpc_id            = aws_vpc.atlantis.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
      name = "${var.app_name}-sb-third"
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "atlantis" {
  vpc_id = aws_vpc.atlantis.id

  tags = {
    name = "${var.app_name}-IGW"
  }

  # Ensuring that the Internet Gateway is created after the VPC
  depends_on = [aws_vpc.atlantis]
}

# Create the Default Route Table for the VPC and add a default route
resource "aws_default_route_table" "example" {
  default_route_table_id = aws_vpc.atlantis.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.atlantis.id
  }

  tags = {
    name = "${var.app_name}-VPC-RT"
  }

  # Ensure the route table depends on the internet gateway creation
  depends_on = [aws_internet_gateway.atlantis]
}

# Create a Security Group for the VPC
resource "aws_security_group" "atlantis" {
  name        = "${var.app_name}-SG"
  description = "Allow TLS inbound traffic and all outbound traffic "
  vpc_id      = aws_vpc.atlantis.id
  
  tags = {
    name = "${var.app_name}-SG"
  }

  # Ensure security group is created after VPC
  depends_on = [aws_vpc.atlantis]
}

# Create Ingress Rules for GitHub Webhook IP ranges
resource "aws_vpc_security_group_ingress_rule" "github_webhook_ingress" {
  for_each = toset(data.github_ip_ranges.waf.hooks)

  security_group_id = aws_security_group.atlantis.id

  # Handle IPv4 CIDR blocks
  cidr_ipv4 = each.key != null && substr(each.key, 0, 1) != "2" ? each.key : null

  # Handle IPv6 CIDR blocks
  cidr_ipv6 = each.key != null && substr(each.key, 0, 1) == "2" ? each.key : null

  from_port   = -1
  to_port     = -1
  ip_protocol = "-1"

  # Ensure this rule is created after the security group
  depends_on = [aws_security_group.atlantis]
}

# Create an Ingress rule for allowing HTTP access from a specific IP
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.atlantis.id

  cidr_ipv4   = "199.126.147.173/32"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  # Ensure this rule is created after the security group
  depends_on = [aws_security_group.atlantis]
}

resource "aws_vpc_security_group_ingress_rule" "allow_SG" {
  security_group_id = aws_security_group.atlantis.id

  referenced_security_group_id  = aws_security_group.atlantis.id
  from_port   = -1
  ip_protocol = "-1"
  to_port     = -1
  # Ensure this rule is created after the security group
  depends_on = [aws_security_group.atlantis]
}

resource "aws_vpc_security_group_egress_rule" "allow_all" {
  security_group_id = aws_security_group.atlantis.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  ip_protocol = "-1"
  to_port     = -1
}

resource "aws_lb" "application_load_balancer" {
  name               = "${var.app_name}-alb" 
  load_balancer_type = "application"
  enable_cross_zone_load_balancing = true
  enable_zonal_shift = false 

  subnets = [ # Referencing the default subnets
   aws_subnet.first.id,
    aws_subnet.second.id,
     aws_subnet.third.id
  ]

  # security group
  security_groups = [aws_security_group.atlantis.id]
}

resource "aws_lb_target_group" "atlantis" {
  name     = "${var.app_name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.atlantis.id
  target_type = "ip"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atlantis.arn
  }
}