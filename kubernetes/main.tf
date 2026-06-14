provider "aws" {
  region = "us-east-1"
  
}


data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

terraform {
  backend "s3" {
    bucket       = "terraform-state-bucket-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-an"
    use_lockfile = true
    region       = "us-east-1"
  }
}


output "name" {
  value = "testt"
}

data "aws_vpc" "default_vpc" {
  default = true
}

output "output_vpc_id" {
  value = data.aws_vpc.default_vpc.id
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

output "output_subnets" {
  value = data.aws_subnets.default_vpc_subnets.ids
}


resource "aws_eks_cluster" "example" {
  name = "example"

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.35"

  vpc_config {
    subnet_ids = data.aws_subnets.default_vpc_subnets.ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}