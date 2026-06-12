provider "aws" {
  region = "us-east-1"
}

output "name" {
  value = "testt"
}

# resource "aws_s3_bucket" "example" {
#   bucket = "b3691909d8800f0e36eeff26aa6e497412"

#   tags = {
#     Name        = "My bucket"
#     Environment = "TEST"
#   }
# }