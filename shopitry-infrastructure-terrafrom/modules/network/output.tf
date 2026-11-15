output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids_by_az" {
  value = {
    for az in var.availability_zones :
    az => aws_subnet.public[az].id
  }
}

output "private_subnet_ids_by_az" {
  value = {
    for az in var.availability_zones :
    az => aws_subnet.private[az].id
  }
}

output "nat_gateway_ids" {
  value = {
    for az, nat in aws_nat_gateway.this :
    az => nat.id
  }
}

output "public_rt_ids" {
  value = {
    for az, rt in aws_route_table.public :
    az => rt.id
  }
}

output "private_rt_ids" {
  value = {
    for az, rt in aws_route_table.private :
    az => rt.id
  }
}