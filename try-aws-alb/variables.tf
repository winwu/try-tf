variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "enable_blue_env" {
  type    = bool
  default = true
}

variable "blue_instance_count" {
  type    = number
  default = 2
}

variable "aws_azs_config" {
  type = object({
    zones           = list(string)
    private_subnets = list(string)
    public_subnets  = list(string)
  })
  default = {
    zones = ["us-west-1b", "us-west-1c"],
    # "available cidr blocks for public subnets"
    public_subnets = [
      "10.0.1.0/24", // 251 IPs
      "10.0.2.0/24", // 251 IPs
    ]
    # available cidr blocks for private subnets
    private_subnets = [
      "10.0.101.0/24", // 251 IPs
      "10.0.102.0/24", // 251 IPs
    ]
  }
}