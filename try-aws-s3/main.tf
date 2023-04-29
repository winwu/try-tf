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

# if content of this bucket can be publicly accessed or not
resource "aws_s3_bucket_public_access_block" "name" {
  bucket = aws_s3_bucket.example-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# create a object
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.example-bucket.id

  # iterate all files under "photos" folder and upload to this object
  # and use the filename as key
  for_each = fileset("photos/", "*")
  key      = each.value
  source   = "photos/${each.value}"
  etag     = filemd5("photos/${each.value}")
  depends_on = [
    aws_s3_bucket.example-bucket
  ]
}