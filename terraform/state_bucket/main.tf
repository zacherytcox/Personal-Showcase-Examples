provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "terraform-state-bucket-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}-an"
  force_destroy = false
  bucket_namespace = "account-regional"
}