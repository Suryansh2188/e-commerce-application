variable "requester_vpc_id" {
  description = "ID of the requester VPC that initiates the VPC peering connection."
  type        = string
}

variable "peer_vpc_id" {
  description = "ID of the target (accepter) VPC with which the requester VPC establishes a peering connection."
  type        = string
}

variable "project_name" {
  type = string
}