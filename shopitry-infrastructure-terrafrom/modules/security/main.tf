# =========================================================
# GATEWAY SECURITY GROUP
# =========================================================

# resource "aws_security_group" "gateway" {
#   name        = "${var.project_name}-gateway-sg"
#   description = "Security group for public gateway EC2"
#   vpc_id      = var.vpc_id

#   tags = {
#     Name = "${var.project_name}-gateway-sg"
#   }
# }


# # HTTP
# resource "aws_vpc_security_group_ingress_rule" "gateway_http" {
#   security_group_id = aws_security_group.gateway.id

#   description = "HTTP"

#   ip_protocol = "tcp"

#   from_port = 80
#   to_port   = 80

#   cidr_ipv4 = "0.0.0.0/0"
# }


# # HTTPS
# resource "aws_vpc_security_group_ingress_rule" "gateway_https" {
#   security_group_id = aws_security_group.gateway.id

#   description = "HTTPS"

#   ip_protocol = "tcp"

#   from_port = 443
#   to_port   = 443

#   cidr_ipv4 = "0.0.0.0/0"
# }


# # SSH
# resource "aws_vpc_security_group_ingress_rule" "gateway_ssh" {
#   security_group_id = aws_security_group.gateway.id

#   description = "SSH administration"

#   ip_protocol = "tcp"

#   from_port = 22
#   to_port   = 22

#   cidr_ipv4 = var.ssh_allowed_cidr
# }


# # Gateway outbound
# resource "aws_vpc_security_group_egress_rule" "gateway_outbound" {
#   security_group_id = aws_security_group.gateway.id

#   description = "Gateway outbound"

#   ip_protocol = "-1"

#   cidr_ipv4 = "0.0.0.0/0"
# }

# =========================================================
# PUBLIC SERVICES SECURITY GROUP
# =========================================================

resource "aws_security_group" "public_services" {
  name        = "${var.project_name}-public-services-sg"
  description = "Security group for public api-gateway"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-public-services-sg"
  }
}

# HTTP
resource "aws_vpc_security_group_ingress_rule" "public" {
  security_group_id = aws_security_group.public_services.id

  description = "Public services inbound"

  ip_protocol = "tcp"

  from_port = 5000
  to_port   = 5000

  cidr_ipv4 = "0.0.0.0/0"
}

# Public service outbound
resource "aws_vpc_security_group_egress_rule" "public_outbound" {
  security_group_id = aws_security_group.public_services.id

  description = "Public services outbound"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}


# =========================================================
# PRIVATE SERVICES SECURITY GROUP
# =========================================================

resource "aws_security_group" "private_services" {
  name        = "${var.project_name}-private-services-sg"
  description = "Security group for private microservices"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-private-services-sg"
  }
}


# Catalog
resource "aws_vpc_security_group_ingress_rule" "catalog" {
  security_group_id = aws_security_group.private_services.id

  description = "Catalog service from gateway"

  ip_protocol = "tcp"

  from_port = 5001
  to_port   = 5001

  cidr_ipv4 = aws_security_group.public_services.id
}


# Cart
resource "aws_vpc_security_group_ingress_rule" "cart" {
  security_group_id = aws_security_group.private_services.id

  description = "Cart service from gateway"

  ip_protocol = "tcp"

  from_port = 5002
  to_port   = 5002

  cidr_ipv4 = aws_security_group.public_services.id
}


# Order
resource "aws_vpc_security_group_ingress_rule" "order" {
  security_group_id = aws_security_group.private_services.id

  description = "Order service from gateway"

  ip_protocol = "tcp"

  from_port = 5003
  to_port   = 5003

  cidr_ipv4 = aws_security_group.public_services.id
}


# Private service outbound
resource "aws_vpc_security_group_egress_rule" "private_outbound" {
  security_group_id = aws_security_group.private_services.id

  description = "Private services outbound"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"
}
