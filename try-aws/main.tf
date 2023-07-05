terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }

  required_version = "~> 1.5.2"
}


locals {
  project_name = "just a nginx page"
}
