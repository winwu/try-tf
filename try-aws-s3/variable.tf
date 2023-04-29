variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "bucket_name" {
  description = "bucket name must be unique"
  type        = string
  default     = "wwu-developer-test-bucket"
}