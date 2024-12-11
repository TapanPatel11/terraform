//----------------------create VPC
resource "aws_vpc" "signoz_vpc" {
  cidr_block = "10.2.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "signoz-vpc"
  }
}

resource "aws_subnet" "signoz_subnet" {
  count                   = 2
  vpc_id                  = aws_vpc.signoz_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.signoz_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "signoz-subnet-${count.index}"
  }
}

data "aws_availability_zones" "available" {}

//----------------------eks cluster
resource "aws_iam_role" "eks_role" {
  name               = "signoz-eks-role"
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role.json
}

data "aws_iam_policy_document" "eks_assume_role" {
  statement {
    actions = ["sts:AssumeRole","sts:TagSession"]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_eks_cluster" "signoz_cluster" {
  name     = "signoz-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.signoz_subnet[*].id
  }

  depends_on = [aws_iam_role.eks_role]
}


//----------------------eks node group 

resource "aws_iam_role" "example" {
  name = "eks-node-group-example"
  
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.example.name
}

# resource "aws_eks_node_group" "signoz_node_group" {
#   cluster_name    = aws_eks_cluster.signoz_cluster.name
#   ami_type = ""
#   node_role_arn   = aws_iam_role.example.arn
#   subnet_ids      = aws_subnet.signoz_subnet[*].id
#   disk_size = 4
#   scaling_config {
#     desired_size = 2
#     max_size     = 3
#     min_size     = 1
#   }
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
#   instance_types = ["t2.micro"]
# }
