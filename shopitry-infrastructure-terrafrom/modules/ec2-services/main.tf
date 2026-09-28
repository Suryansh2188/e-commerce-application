resource "aws_instance" "this" {
  for_each = var.services

  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id = each.value.public ? var.public_subnet_id : var.private_subnet_id

  private_ip = each.value.private_ip

  associate_public_ip_address = each.value.public

  vpc_security_group_ids = [
    each.value.public
      ? var.public_services_security_group_id
      : var.private_services_security_group_id
  ]

  tags = {
    Name         = each.value.name
    Project      = var.project_name
    Microservice = each.value.folder
    Environment  = "production"
  }
}