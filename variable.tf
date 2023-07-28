# Default variables
variable "EC2_API_STOP" {
  type    = bool
  default = true
}

variable "EC2_API_TERMINATION" {
  type    = bool
  default = true
}

# S3 backend bucketname
variable "s3_terraform_backup_bucket_name" {
  type    = bool
  default = true
}

# VPC Variables
variable "vpc_name" {
  type    = string
  default = "vpc"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/26"
}

variable "vpc_instance_tenancy" {
  type    = string
  default = "default"
}

variable "vpc_tags" {
  type    = map(any)
  default = {}
}

# public subnet variables
variable "pub_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "pub_az" {
  type    = list(string)
  default = []
}

variable "pub_ip_on_launch" {
  type    = bool
  default = true
}

variable "pub_subnet_tags" {
  type    = map(any)
  default = {}
}

# private subnet variables
variable "prv_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "prv_az" {
  type    = list(string)
  default = []
}

variable "prv_subnet_tags" {
  type    = map(any)
  default = {}
}

# Internet Gateway variables
variable "gw_tags" {
  type    = map(any)
  default = {}
}

# Elasitc IP variables
variable "eip_tags" {
  type    = map(any)
  default = {}
}

# Nat Gateway variables
variable "nat_gateway_tags" {
  type    = map(any)
  default = {}
}

# default Route Table variables
variable "default_rt_tags" {
  type    = map(any)
  default = {}
}

# Pub Route Table variables
variable "pub_rt_tags" {
  type    = map(any)
  default = {}
}

# Default Network ACL variables
variable "default_ingress" {
  type = any
  default = [
    {
      "protocol"   = "-1"
      "rule_no"    = "100"
      "action"     = "allow"
      "cidr_block" = "0.0.0.0/0"
      "from_port"  = "0"
      "to_port"    = "0"
    }
  ]
}

variable "default_egress" {
  type = any
  default = [
    {
      "protocol"   = "-1"
      "rule_no"    = "100"
      "action"     = "allow"
      "cidr_block" = "0.0.0.0/0"
      "from_port"  = "0"
      "to_port"    = "0"
    }
  ]
}

variable "default_nacl_tags" {
  type    = map(any)
  default = {}
}

# Public Network ACL variables
variable "pub_nacl_ingress" {
  type    = any
  default = [{}]
}

variable "pub_nacl_egress" {
  type    = any
  default = [{}]
}

variable "pub_nacl_tags" {
  type    = map(any)
  default = {}
}


# Security Group Variables
variable "vpc_private_sg" {
  type    = string
  default = ""
}

variable "vpc_private_sg_description" {
  type    = string
  default = ""
}

variable "vpc_private_sg_ingress" {
  type    = any
  default = [{}]
}

variable "vpc_private_sg_egress" {
  type = any
  default = [
    {
      "from_port"        = "0"
      "to_port"          = "0"
      "protocol"         = "-1"
      "cidr_blocks"      = ["0.0.0.0/0"]
      "ipv6_cidr_blocks" = ["::/0"]
    }
  ]
}

variable "vpc_private_sg_tags" {
  type    = map(any)
  default = {}
}

# ec2 instance role for console ssh to instance
variable "ec2_instance_role_name" {
  type    = string
  default = ""
}

variable "ec2_instance_role_tags" {
  type    = map(any)
  default = {}
}

# ec2 instance profile name
variable "ec2_instance_role_instance_profile_name" {
  type    = string
  default = ""
}

# Instance connect policy
variable "instance_connect_policy_name" {
  type    = string
  default = ""
}

variable "instance_connect_policy_description" {
  type    = string
  default = ""
}

# ec2 instance key pair variables
variable "ec2_key_pair_name" {
  type    = string
  default = ""
}

variable "ec2_key_pair_public_key" {
  type    = string
  default = ""
}

# private ec2 instance variables
variable "private_ec2_name" {
  type    = string
  default = ""
}

variable "private_ec2_ami" {
  type    = string
  default = ""
}

variable "private_ec2_type" {
  type    = string
  default = "t2.micro"
}

variable "private_ec2_root_block_device" {
  type    = any
  default = [{}]
}

variable "private_ec2_tags" {
  type    = map(any)
  default = {}
}