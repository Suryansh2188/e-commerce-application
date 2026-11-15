# =========================================================
# NETWORK
# =========================================================

module "network" {
  source = "./modules/network"

  project_name = var.project_name

  aws_region = var.aws_region

  availability_zones = var.availability_zones

  vpc_cidr = var.vpc_cidr

  public_subnet_cidrs = var.public_subnet_cidrs

  private_subnet_cidrs = var.private_subnet_cidrs
}


# =========================================================
# SECURITY
# =========================================================

module "security" {
  source = "./modules/security"

  project_name = var.project_name

  vpc_id = module.network.vpc_id
}


# =========================================================
# LAMBDA + API GATEWAY
# =========================================================

# module "lambda_services" {
#   source = "./modules/lambda-services"

#   project_name = var.project_name

#   stage_name = "prod"
# }


# =========================================================
# EC2 MICROSERVICES
# =========================================================

module "ec2_services" {
  source = "./modules/ec2-services"

  project_name = var.project_name

  ami_id = var.ami_id

  instance_type = var.instance_type

  key_name = var.key_name

  public_subnet_id = module.network.public_subnet_ids_by_az["us-east-1a"]

  private_subnet_id = module.network.private_subnet_ids_by_az["us-east-1a"]

  public_services_security_group_id = module.security.public_services_security_group_id

  private_services_security_group_id = module.security.private_services_security_group_id

  services = var.services
}

module "lambda_functions" {
  source = "./modules/lambda-functions"

  aws_region = var.aws_region
}

# Fetch the default VPC for the current region
data "aws_vpc" "default" {
  default = true
}

module "vpc_peering" {
  source       = "./modules/vpc-peering"
  project_name = var.project_name

  requester_vpc_id = data.aws_vpc.default.id
  peer_vpc_id      = module.network.vpc_id
}


module "vpc_peering_routing" {
  source = "./modules/vpc-peering-routing"

  instance_id               = var.instance_id
  peer_vpc_cidr             = var.vpc_cidr
  default_vpc_cidr          = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_connection_id

  public_rt_ids  = module.network.public_rt_ids
  private_rt_ids = module.network.private_rt_ids

  public_sg_id  = module.security.public_services_security_group_id
  private_sg_id = module.security.private_services_security_group_id
}
