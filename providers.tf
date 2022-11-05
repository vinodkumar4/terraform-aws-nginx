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

module "bootstrap" {
  source                      = "./terraform-modules/modules/bootstrap"
  name_of_s3_bucket           = "s3-bucket-for-terraform-singapre-vinod"
  dynamo_db_table_name        = "aws-terraform-locks"
}