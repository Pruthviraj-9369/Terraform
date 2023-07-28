# Provisioning instance key pair with our keys
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.ec2_key_pair_name
  public_key = var.ec2_key_pair_public_key
}

# provisioning ec2 instance connect endpoint to ssh into ec2 instance
resource "aws_ec2_instance_connect_endpoint" "ec2_instance_connect" {
  subnet_id = element(aws_subnet.prv_subnet.*.id, 0)
  security_group_ids= [aws_security_group.vpc_private_sg.id]
}

# provisioning ec2 instance
resource "aws_instance" "private_ec2" {
  ami                     = var.private_ec2_ami
  instance_type           = var.private_ec2_type
  subnet_id               = element(aws_subnet.prv_subnet.*.id, 0)
  vpc_security_group_ids  = [aws_security_group.vpc_private_sg.id]
  iam_instance_profile    = aws_iam_instance_profile.instance_profile_ec2_instance_role.name
  disable_api_stop        = var.EC2_API_STOP
  disable_api_termination = var.EC2_API_TERMINATION

  dynamic "root_block_device" {
    for_each = var.private_ec2_root_block_device

    content {
      delete_on_termination = lookup(root_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(root_block_device.value, "encrypted", null)
      iops                  = lookup(root_block_device.value, "iops", null)
      kms_key_id            = lookup(root_block_device.value, "kms_key_id", null)
      tags                  = lookup(root_block_device.value, "tags", null)
      throughput            = lookup(root_block_device.value, "throughput", null)
      volume_size           = lookup(root_block_device.value, "volume_size", null)
      volume_type           = lookup(root_block_device.value, "volume_type", null)
    }
  }
  key_name = aws_key_pair.ec2_key_pair.key_name
  user_data = <<EOF
  #!/bin/bash
  sudo yum install ec2-instance-connect
  EOF
  tags = merge(tomap({
    "Name" = var.private_ec2_name,
  }), var.private_ec2_tags)
}