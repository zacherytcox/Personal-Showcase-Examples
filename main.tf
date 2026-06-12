provider "aws" {
  region = "us-east-1"
}

output "name" {
  value = "test"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "TEST"
  }
}