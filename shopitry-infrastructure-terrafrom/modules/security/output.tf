# output "gateway_security_group_id" {
#   value = aws_security_group.gateway.id
# }

output "public_services_security_group_id" {
  value = aws_security_group.public_services.id
}

output "private_services_security_group_id" {
  value = aws_security_group.private_services.id
}