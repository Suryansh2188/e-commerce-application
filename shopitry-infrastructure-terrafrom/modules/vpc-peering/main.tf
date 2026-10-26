resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.peer_vpc_id
  auto_accept = true

  tags = {
    Name = "VPC Peering between Default-vpc and ${var.project_name}-vpc"
  }
}

