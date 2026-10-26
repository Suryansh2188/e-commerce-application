output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_id
}

output "private_subnet_id" {
  value = module.network.private_subnet_id
}


output "gateway_public_ip" {
  value = module.ec2_services.public_ips["gateway"]
}


output "catalog_private_ip" {
  value = module.ec2_services.private_ips["catalog"]
}


output "cart_private_ip" {
  value = module.ec2_services.private_ips["cart"]
}


output "order_private_ip" {
  value = module.ec2_services.private_ips["order"]
}

output "payment_function_url" {
  value = module.lambda_functions.payment_function_url
}

output "payment_lambda_function_arn" {
  value = module.lambda_functions.payment_lambda_function_arn
}

output "notification_function_url" {
  value = module.lambda_functions.notification_function_url
}

output "notification_lambda_function_arn" {
  value = module.lambda_functions.notification_lambda_function_arn
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection."
  value       = module.vpc_peering.vpc_peering_connection_id
}

output "vpc_peering_connection_status" {
  description = "Status of the VPC peering connection request."
  value       = module.vpc_peering.vpc_peering_connection_status
}