terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

# create a s3 bucket
resource "aws_s3_bucket" "example-bucket" {
  bucket = var.bucket_name
}

# versioning enabled or disabled
# resource "aws_s3_bucket_versioning" "example-bucket-version" {
#   bucket = aws_s3_bucket.example-bucket.id
#   versioning_configuration {
#     # status = "Disabled" 
#     status = "Disabled" 
#   }
# }