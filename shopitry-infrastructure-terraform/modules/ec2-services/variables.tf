variable "project_name" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "public_services_security_group_id" {
  type = string
}

variable "private_services_security_group_id" {
  type = string
}

variable "services" {
  type = map(object({
    name          = string
    folder        = string
    port          = number
    private_ip    = string
    public        = bool
  }))
}