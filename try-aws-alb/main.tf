provider "aws" {
  profile = "default"
  region  = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "load-balance-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.aws_azs_config.zones
  private_subnets = var.aws_azs_config.private_subnets
  public_subnets  = var.aws_azs_config.public_subnets

  # do not turn on both unless it's necessary... 
  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    "try-aws-alb" = "dev"
  }
}

module "web_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-sg"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/16"]
}

module "lb_security_group" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "lb-sg"
  description = "security group for load balancer with HTTP ports"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet
resource "random_pet" "app" {
  length    = 2
  separator = "-"
}

resource "aws_lb" "app" {
  name               = "app-${random_pet.app.id}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [module.vpc.public_subnets]
  security_groups    = [module.lb_security_group.security_group_id]
}

resource "aws_lb_listener" "app" {
  # direct all traffic to blue load balancing target group on port 80
  load_balancer_arn = aws_lb.app.arn
  port              = "80"
  protocol          = "HTTP"

  # route traffic to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}