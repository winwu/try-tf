variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "aws_azs" {
  type = list(string)
  # values = ["us-west-1b"]
  values = ["us-west-1b", "us-west-1c"]
}

variable "public_subnet_cidrs" {
  description = "available cidr blocks for public subnets"
  type        = list(string)
  default = [
    "10.0.1.0/24", // 251 IPs
    "10.0.2.0/24", // 251 IPs
  ]
}

variable "private_subnet_cidrs" {
  description = "available cidr blocks for private subnets"
  type        = list(string)
  default = [
    "10.0.101.0/24", // 251 IPs
    "10.0.102.0/24", // 251 IPs
  ]
}

variable "enable_blue_env" {
  type    = bool
  default = true
}

variable "blue_instance_count" {
  type    = number
  default = 2
}