variable "name" {
  type    = string
  default = "gateway-alb"
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}