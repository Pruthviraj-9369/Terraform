terraform {
  backend "s3" {
    bucket = var.s3_terraform_backup_bucket_name
    key    = "vpc/vpc-poc.tfstate"
    region = "us-east-1"

    # DynamoDB table for state files lock
    # This can avoid concurrent terraform apply actions
    # One will error out with unable to unlock file message
    dynamodb_table = "vpc-tfstate-lock"
  }
}