output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "pub_subnet_ids" {
  value = [for subnet in aws_subnet.pub_subnet : subnet.id]
}

output "prv_subnet_ids" {
  value = [for subnet in aws_subnet.prv_subnet : subnet.id]
}

output "gw_id" {
  value = aws_internet_gateway.gw.id
}

output "eip_id" {
  value = aws_eip.eip.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}

output "default_rt_id" {
  value = aws_default_route_table.default_rt.id
}

output "pub_rt_id" {
  value = aws_route_table.pub_rt.id
}

output "default_nacl_id" {
  value = aws_default_network_acl.default_nacl.id
}

output "pub_nacl_id" {
  value = aws_network_acl.pub_nacl.id
}

output "iam_role_id" {
  value = aws_iam_role.ec2_instance_role.id
}

output "sg_id" {
  value = aws_security_group.vpc_private_sg.id
}

output "key_pair_id" {
  value = aws_key_pair.ec2_key_pair.id
}

output "ec2_instance_id" {
  value = aws_instance.private_ec2.id
}