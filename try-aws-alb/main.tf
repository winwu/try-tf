provider "aws" {
  profile = "default"
  region  = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "alb-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.aws_azs
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  # do not turn on both unless it's necessary... 
  # it will cost $$$
  # @TODO
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    is_practice = "true"
    Environment = "dev"
  }
}


module "web_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16"]
}