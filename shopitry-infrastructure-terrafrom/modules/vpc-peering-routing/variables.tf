variable "instance_id" {
  description = "ID of the existing EC2 instance whose subnet and route table will be discovered."
  type        = string
}

variable "peer_vpc_cidr" {
  type = string
}

variable "vpc_peering_connection_id" {
  type = string
}

variable "private_rt_id" {
  type = string
}

variable "public_rt_id" {
  type = string
}

variable "public_sg_id" {
  type = string
}

variable "private_sg_id" {
  type = string
}

variable "default_vpc_cidr" {
  type = string
}