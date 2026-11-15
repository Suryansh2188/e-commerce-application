variable "name" {
  type    = string
  default = "gateway-target-group"
}

variable "vpc_id" {
  type = string
}

variable "gateway_instance_id" {
  type = string
}

variable "health_check_path" {
  type    = string
  default = "/health"
}