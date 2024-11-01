terraform {
  required_version = ">=1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }
  backend "s3" {
    profile        = "default"
    bucket         = "wasabi-terraform-states"
    dynamodb_table = "wasabi-tf"
    region         = "us-east-1"
    key            = "wasabi-test-task.hcl"
  }
}

provider "aws" {
  profile = var.profile
  region  = var.region
}