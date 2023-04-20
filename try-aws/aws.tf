resource "aws_instance" "app_server" {
  # make sure this ami exists in the region which specify in provider.tf > region
  ami           = "ami-09c5c62bac0d0634e"
  instance_type = var.instance_type

  tags = {
    Name = "ExampleAppServerInstance-${local.project_name}"
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-1b", "us-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}