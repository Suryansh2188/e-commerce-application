output "alb_dns_name" {
  value = aws_lb.gateway_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.gateway_alb.zone_id
}

output "alb_arn" {
  value = aws_lb.gateway_alb.arn
}