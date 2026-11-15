output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_id" {
  value = module.network.public_subnet_ids_by_az
}

output "private_subnet_id" {
  value = module.network.private_subnet_ids_by_az
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

output "alb_security_group_id" {
  description = "ALB security group ID"
  value = module.security.alb_security_group_id
}

output "alb_target_group_arn" {
  description = "ALB target group ARN."
  value = module.alb_target_group.target_group_arn
}

output "alb_arn" {
  description = "ARN of alb"
  value = module.alb.alb_arn
}