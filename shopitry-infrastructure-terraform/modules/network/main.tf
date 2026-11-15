# =========================================================
# LOCAL VALUES
# =========================================================

locals {
  az_map = {
    for index, az in var.availability_zones :
    az => index
  }
}

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}


# =========================================================
# PUBLIC SUBNET
# =========================================================

resource "aws_subnet" "public" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

  cidr_block = var.public_subnet_cidrs[each.value]

  availability_zone = each.key

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-${each.key}"
  }
}


# =========================================================
# PRIVATE SUBNET
# =========================================================

resource "aws_subnet" "private" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

  cidr_block = var.private_subnet_cidrs[each.value]

  availability_zone = each.key

  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project_name}-private-${each.key}"
  }
}


# =========================================================
# INTERNET GATEWAY
# =========================================================

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}


# =========================================================
# NAT ELASTIC IP - ONE PER AZ
# =========================================================

resource "aws_eip" "nat" {
  for_each = local.az_map

  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-${each.key}"
  }
}

# =========================================================
# NAT GATEWAY - ONE PER AZ
# =========================================================
resource "aws_nat_gateway" "this" {
  for_each = local.az_map

  allocation_id = aws_eip.nat[each.key].id

  subnet_id = aws_subnet.public[each.key].id

  depends_on = [
    aws_internet_gateway.this
  ]

  tags = {
    Name = "${var.project_name}-nat-${each.key}"
  }
}



# =========================================================
# PUBLIC ROUTE TABLE
# =========================================================

resource "aws_route_table" "public" {
  for_each = local.az_map
  
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.project_name}-public-route-table"
  }
}

# =========================================================
# PUBLIC SUBNET ROUTE TABLE ASSOCIATION
# =========================================================

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id = each.value.id

  route_table_id = aws_route_table.public[each.key].id
}


# =========================================================
# PRIVATE ROUTE TABLES - ONE PER AZ
# =========================================================

resource "aws_route_table" "private" {
  for_each = local.az_map

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.this[each.key].id
  }

  tags = {
    Name = "${var.project_name}-private-route-table-${each.key}"
  }
}


# =========================================================
# PRIVATE SUBNET ROUTE TABLE ASSOCIATIONS
# =========================================================

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id = each.value.id

  route_table_id = aws_route_table.private[each.key].id
}