# Try Aws
# this example is to initial a simple web service



/* Instance */


resource "aws_instance" "web_server" {
  # make sure this ami exists in the region which specify in provider.tf > region
  ami = "ami-014d05e6b24240371"

  instance_type = var.aws_instance_type

  subnet_id = aws_subnet.dev-vpc-subnet-public.id

  # public ssh key
  key_name = aws_key_pair.us-west-1-key-pair-public.id

  # policy about how to connect to this ec2
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]

  # copy folder to ec2
  provisioner "file" {
    source      = "nginx.sh"
    destination = "/tmp/nginx.sh"
  }

  # install nginx
  # user data example:
  # user_data = <<EOF
  #   #! /bin/bash
  #   sudo apt update -y &&
  #   sudo apt install -y nginx
  #   echo "example of init ec2 vis terraform!" > /var/www/html/index.html
  # EOF
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "sudo /tmp/nginx.sh"
    ]
  }

  # login to ec2 with the private key
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(var.aws_intance_private_key)
    timeout     = "3m"
  }

  tags = {
    Name = "ec2-of-${local.project_name}"
  }
}

# public key for aws instance
resource "aws_key_pair" "us-west-1-key-pair-public" {
  key_name   = "us-west-1-region-key-pair"
  public_key = file(var.aws_intance_public_key)
}


/* Networking */


# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc-from-terraform"
#   cidr = "10.0.0.0/16"

#   # azs             = ["us-west-1b", "us-west-1c"]
#   # private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#   # public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

#   # do not turn on both unless it's necessary... 
#   # it will cost $$$
#   enable_nat_gateway = false
#   enable_vpn_gateway = false

#   tags = {
#     is_practice = "true"
#     Environment = "dev"
#   }
# }

# create VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true" # gives you an internal domain name
  enable_dns_hostnames = "true" # gives you an internal host name

  tags = {
    name = "dev vpc"
  }
}

# create public subnet under vpc "dev-vpc"
resource "aws_subnet" "dev-vpc-subnet-public" {
  # get the vpc id which we just created
  vpc_id = aws_vpc.dev-vpc.id

  # but this is optional
  availability_zone = "us-west-1b"

  # available ip will be 251 in this subnet
  cidr_block = "10.0.1.0/24"

  # auto assigne a public IP address as long as instances launched into the subnet
  map_public_ip_on_launch = "true"

  tags = {
    Name = "dev vpc subnet public"
  }
}

# create gw
# the vpc require an IGW to communicated over the internet
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
}

# create routing table
resource "aws_route_table" "dev-public-crt" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    # let associated subnet can reach internet
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  tags = {
    name = "dev public rt"
  }
}

resource "aws_route_table_association" "dev-public-crt-association" {
  subnet_id      = aws_subnet.dev-vpc-subnet-public.id
  route_table_id = aws_route_table.dev-public-crt.id
}


# allow ssh and web http access
resource "aws_security_group" "allow-ssh" {
  name        = "allow-ssh"
  description = "allow SSH inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    # -1 equivalent to all
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    # [CAUTION!] do not type this in prod env
    # allow all ip address to ssh it
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
