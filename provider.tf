################################################################
#                                                              #
#    Terraform Provider Config Using AWS IAM Role Assumption   #
#                                                              #
################################################################
# Terraform version is 1.4.4
# AWS Provider Version is 4.56.0
terraform {
  required_version = "1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }
}

# We can access aws with assume role or providing credentials. 
# It is best practice to use assume role


provider "aws" {
  assume_role {
    role_arn     = ""
    session_name = "terraform"
  }
  #region = 
  #profile = 

  # By using default tags helps us to assgin tags to every resource that created
  # This terraform script.
  default_tags {
    tags = {
      project     = "vpc"
      environment = "poc"
    }
  }
}