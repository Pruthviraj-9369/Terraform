#I refer to /26 cidr masking which provides 62 hosting ip address in this VPC
vpc_name             = "vpc"
vpc_cidr_block       = "10.0.0.0/26"
vpc_instance_tenancy = "default"

#I refer to /28 cidr masking which provides 30 hosting ip address in this public subnet
pub_subnet_cidrs = ["10.0.0.0/27"]
pub_az           = ["us-east-1a"]

#I refer to /29 cidr masking which provides 14 hosting ip address in each of private subnets
prv_subnet_cidrs = ["10.0.0.32/28", "10.0.0.48/28"]
prv_az           = ["us-east-1a", "us-east-1b"]

#Public NACL
pub_nacl_ingress = [
  {
    "protocol"   = "-1"
    "rule_no"    = "100"
    "action"     = "allow"
    "cidr_block" = "0.0.0.0/0"
    "from_port"  = "0"
    "to_port"    = "0"
  }
]

pub_nacl_egress = [
  {
    "protocol"   = "-1"
    "rule_no"    = "100"
    "action"     = "allow"
    "cidr_block" = "0.0.0.0/0"
    "from_port"  = "0"
    "to_port"    = "0"
  }
]

vpc_private_sg             = "allow-ssh-from-private-subnet"
vpc_private_sg_description = "Allows ssh between the resouces that created in private subnets"
vpc_private_sg_ingress = [
  {
    "description" = "Allow ssh for private subnets"
    "from_port"   = "22"
    "to_port"     = "22"
    "protocol"    = "tcp"
    "cidr_blocks" = ["10.0.0.32/28", "10.0.0.48/28"]
  }
]

# ec2 instance iam role
ec2_instance_role_name = "private-ec2-role"
ec2_instance_role_tags = {}

ec2_instance_role_instance_profile_name = "private-ec2-instance-profile-role"

# instance connect policy name
instance_connect_policy_name        = "instance-connect"
instance_connect_policy_description = "It allows IAM users to ssh ec2 instances"

# ec2 instance key pair details
ec2_key_pair_name       = "private-ec2-key"
ec2_key_pair_public_key = ""

# private ec2 instance
private_ec2_name = "private-ec2"
private_ec2_ami  = ""
private_ec2_type = "t2.micro"
private_ec2_root_block_device = [
  {
    "delete_on_termination" = "false"
    "encrypted"             = "true"
    "volume_type"           = "gp2"
    "volume_size"           = "8"
  }
]