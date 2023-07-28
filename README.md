**Terraform Infrastructure Template**

This Terraform code provisions One VPC with One public and two private subnets
It also provisions ec2 instance in one of private subnet.

Additionally, we leveraged usage of ec2 instance connect and SSM connect to SSH into ec2 instance.


**Pre-requisites**:

To provision above infrastructure we need to provide appropriate AMI id to variable "private_ec2_ami” and public key to variable "ec2_key_pair_public_key" in terraform.tfvars file.

To SSH ec2 instance through ec2 instance connect endpoint we need to white list our ip to security group associated to instance connect.

we need to provide assume role or credentials profile to authenticate to aws account.

We also need to provide backend s3 bucket and DynamoDB details as well in backend.tf file.

