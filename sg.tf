# This sg allows to ssh into resources that provisioned in private subnets
resource "aws_security_group" "vpc_private_sg" {
  name        = var.vpc_private_sg
  description = var.vpc_private_sg_description
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.vpc_private_sg_ingress

    content {
      description      = lookup(ingress.value, "description", null)
      from_port        = lookup(ingress.value, "from_port", null)
      to_port          = lookup(ingress.value, "to_port", null)
      protocol         = lookup(ingress.value, "protocol", null)
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
    }
  }

  dynamic "egress" {
    for_each = var.vpc_private_sg_egress

    content {
      description      = lookup(egress.value, "description", null)
      from_port        = lookup(egress.value, "from_port", null)
      to_port          = lookup(egress.value, "to_port", null)
      protocol         = lookup(egress.value, "protocol", null)
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
    }
  }

  tags = var.vpc_private_sg_tags
}