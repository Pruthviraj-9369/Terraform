#########################################################################################
#                                                                                       #             
#    This Networking Terraform code help us to create One Vitrual Private Cloud (VPC)   #
#    with inter dependent services and connections to those services.                   #
#                                                                                       #
#########################################################################################

# VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = var.vpc_instance_tenancy

  tags = merge(tomap({
    "Name" = var.vpc_name
  }), var.vpc_tags)
}

# Public Subnets
resource "aws_subnet" "pub_subnet" {
  count                   = length(var.pub_subnet_cidrs)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.pub_subnet_cidrs, count.index)
  availability_zone       = var.pub_az[count.index]
  map_public_ip_on_launch = var.pub_ip_on_launch

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-pub-subnet-${count.index + 1}",
  }), var.pub_subnet_tags)
}

# Private Subnets
resource "aws_subnet" "prv_subnet" {
  count             = length(var.prv_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.prv_subnet_cidrs, count.index)
  availability_zone = var.prv_az[count.index]
  tags = merge(tomap({
    "Name" = "${var.vpc_name}-prv-subnet-${count.index + 1}",
  }), var.prv_subnet_tags)
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-gw"
  }), var.gw_tags)
}

# Elastic IP
resource "aws_eip" "eip" {
  tags = merge(tomap({
    "Name" = "${var.vpc_name}-eip",
  }), var.eip_tags)
}

# Nat Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = element(aws_subnet.pub_subnet.*.id, 0)
  tags = merge(tomap({
    "Name" = "${var.vpc_name}-nat-gateway",
  }), var.nat_gateway_tags)
}

# Default Route Table
resource "aws_default_route_table" "default_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-default-rt",
  }), var.default_rt_tags)
}

# Associating pvt Subnet to default Route Table
resource "aws_route_table_association" "default_rt_association" {
  count          = length(var.prv_subnet_cidrs)
  subnet_id      = element(aws_subnet.prv_subnet.*.id, count.index)
  route_table_id = aws_default_route_table.default_rt.id
}

# Public Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-pub-rt",
  }), var.pub_rt_tags)
}

# Associating Public Subnet to Public Route Table
resource "aws_route_table_association" "pub_rt_association" {
  count          = length(var.pub_subnet_cidrs)
  subnet_id      = element(aws_subnet.pub_subnet.*.id, count.index)
  route_table_id = aws_route_table.pub_rt.id
}

# Default NACL
resource "aws_default_network_acl" "default_nacl" {
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id

  dynamic "ingress" {
    for_each = var.default_ingress

    content {
      protocol   = lookup(ingress.value, "protocol", null)
      rule_no    = lookup(ingress.value, "rule_no", null)
      action     = lookup(ingress.value, "action", null)
      cidr_block = lookup(ingress.value, "cidr_block", null)
      from_port  = lookup(ingress.value, "from_port", null)
      to_port    = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.default_egress

    content {
      protocol   = lookup(egress.value, "protocol", null)
      rule_no    = lookup(egress.value, "rule_no", null)
      action     = lookup(egress.value, "action", null)
      cidr_block = lookup(egress.value, "cidr_block", null)
      from_port  = lookup(egress.value, "from_port", null)
      to_port    = lookup(egress.value, "to_port", null)
    }
  }

  tags = merge(tomap({
    "Name" = "${var.vpc_name}-default-nacl",
  }), var.default_nacl_tags)
}

# Associating Default NACL to private subnet
resource "aws_network_acl_association" "default_nacl_association" {
  count          = length(var.prv_subnet_cidrs)
  network_acl_id = aws_default_network_acl.default_nacl.id
  subnet_id      = element(aws_subnet.prv_subnet.*.id, count.index)
}


# Public NACL
resource "aws_network_acl" "pub_nacl" {
  vpc_id = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.pub_nacl_ingress

    content {
      protocol   = lookup(ingress.value, "protocol", null)
      rule_no    = lookup(ingress.value, "rule_no", null)
      action     = lookup(ingress.value, "action", null)
      cidr_block = lookup(ingress.value, "cidr_block", null)
      from_port  = lookup(ingress.value, "from_port", null)
      to_port    = lookup(ingress.value, "to_port", null)
    }
  }

  dynamic "egress" {
    for_each = var.pub_nacl_egress

    content {
      protocol   = lookup(egress.value, "protocol", null)
      rule_no    = lookup(egress.value, "rule_no", null)
      action     = lookup(egress.value, "action", null)
      cidr_block = lookup(egress.value, "cidr_block", null)
      from_port  = lookup(egress.value, "from_port", null)
      to_port    = lookup(egress.value, "to_port", null)
    }
  }
  tags = merge(tomap({
    "Name" = "${var.vpc_name}-pub-nacl",
  }), var.pub_nacl_tags)
}

# Association Public subnet to Public NACL
resource "aws_network_acl_association" "pub_nacl" {
  count          = length(var.pub_subnet_cidrs)
  network_acl_id = aws_network_acl.pub_nacl.id
  subnet_id      = element(aws_subnet.pub_subnet.*.id, count.index)
}