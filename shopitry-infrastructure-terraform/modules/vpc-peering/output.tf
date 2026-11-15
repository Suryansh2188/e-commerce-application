output "vpc_peering_connection_status" {
  description = "Status of the VPC peering connection request."
  value       = aws_vpc_peering_connection.vpc_peering.accept_status
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection."
  value       = aws_vpc_peering_connection.vpc_peering.id
}