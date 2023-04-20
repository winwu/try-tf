terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  # Configuration options
  # touch and edit ~/.aws/credentials
  # [default]
  # aws_access_key_id=
  # aws_secret_access_
  # and run command: "aws configure" in terminal

  profile = "default"
  region  = "us-west-1"
}