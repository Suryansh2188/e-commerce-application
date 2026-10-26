# 1. Look up the existing EC2 instance
data "aws_instance" "existing" {
  instance_id = var.instance_id
}

# 2. NEW: Fetch the subnet details using the instance's subnet_id
data "aws_subnet" "instance_subnet_data" {
  id = data.aws_instance.existing.subnet_id
}

# 3. Find the Main Route Table using the vpc_id extracted from the subnet
data "aws_route_table" "instance_subnet" {
  vpc_id = data.aws_subnet.instance_subnet_data.vpc_id # <- This now works!

  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# 4. Add a route to the peer VPC through the peering connection
resource "aws_route" "to_peer_vpc" {
  route_table_id            = data.aws_route_table.instance_subnet.id
  destination_cidr_block    = var.peer_vpc_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}


# Microservices private route table entry
resource "aws_route" "private_rt" {
  route_table_id = var.private_rt_id
  destination_cidr_block = var.default_vpc_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

# API Gateway public route table entry
resource "aws_route" "public_rt" {
  route_table_id = var.public_rt_id
  destination_cidr_block = var.default_vpc_cidr
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

# API Gateway public security group entry
resource "aws_vpc_security_group_ingress_rule" "public_sg" {
  security_group_id = var.public_sg_id

  description = "Ansible inbound rule"

  ip_protocol = "tcp"

  from_port = 22
  to_port   = 22

  cidr_ipv4 = format(
    "%s/32",
    data.aws_instance.existing.private_ip
  )
}

# Microservices private security group entry
resource "aws_vpc_security_group_ingress_rule" "private_sg" {
  security_group_id = var.private_sg_id

  description = "Ansible inbound rule"

  ip_protocol = "tcp"

  from_port = 22
  to_port   = 22

  cidr_ipv4 = format(
    "%s/32",
    data.aws_instance.existing.private_ip
  )
}