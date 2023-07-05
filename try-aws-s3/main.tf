terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }

  required_version = "~> 1.5.2"
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
# below settings means this bucket is private
resource "aws_s3_bucket_public_access_block" "name" {
  bucket = aws_s3_bucket.example-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# upload local files as object to this created bucket
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.example-bucket.id

  # iterate all files under "photos" folder and upload to this object
  # and use the filename as key
  for_each = fileset("files/", "*")
  key      = each.value
  source   = "files/${each.value}"
  etag     = filemd5("files/${each.value}")
  depends_on = [
    aws_s3_bucket.example-bucket
  ]
}

// https://hands-on.cloud/terraform-s3-examples/