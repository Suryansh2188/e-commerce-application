output "instance_ids" {
  value = {
    for key, instance in aws_instance.this :
    key => instance.id
  }
}

output "private_ips" {
  value = {
    for key, instance in aws_instance.this :
    key => instance.private_ip
  }
}

output "public_ips" {
  value = {
    for key, instance in aws_instance.this :
    key => instance.public_ip
    if instance.public_ip != ""
  }
}