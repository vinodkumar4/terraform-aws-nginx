terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket         = "s3-bucket-for-terraform-singapre-vinod"
    key            = "terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "aws-terraform-locks"
  }
}