variable "aws_region" {
  type    = string
  default = "us-west-1"
}


variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "aws_intance_private_key" {
  default = "us-west-1-region-key-pair"
}

variable "aws_intance_public_key" {
  default = "us-west-1-region-key-pair.pub"
}