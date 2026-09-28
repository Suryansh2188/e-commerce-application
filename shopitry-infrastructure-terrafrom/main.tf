# =========================================================
# NETWORK
# =========================================================

module "network" {
  source = "./modules/network"

  project_name = var.project_name

  aws_region = var.aws_region

  availability_zone = var.availability_zone

  vpc_cidr = var.vpc_cidr

  public_subnet_cidr = var.public_subnet_cidr

  private_subnet_cidr = var.private_subnet_cidr
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

  public_subnet_id = module.network.public_subnet_id

  private_subnet_id = module.network.private_subnet_id

  public_services_security_group_id = module.security.public_services_security_group_id

  private_services_security_group_id = module.security.private_services_security_group_id

  services = var.services
}

module "lambda_functions" {
  source = "./modules/lambda-functions"

  aws_region = var.aws_region
}



resource "local_file" "terraform_outputs" {
  filename = "${path.root}/generated/terraform-outputs.env"

  content = <<-EOT
VPC_ID=${module.network.vpc_id}

PUBLIC_SUBNET_ID=${module.network.public_subnet_id}
PRIVATE_SUBNET_ID=${module.network.private_subnet_id}

GATEWAY_PUBLIC_IP=${module.ec2_services.public_ips["gateway"]}
GATEWAY_PRIVATE_IP=${module.ec2_services.private_ips["gateway"]}

CATALOG_PRIVATE_IP=${module.ec2_services.private_ips["catalog"]}
CART_PRIVATE_IP=${module.ec2_services.private_ips["cart"]}
ORDER_PRIVATE_IP=${module.ec2_services.private_ips["order"]}

PAYMENT_SERVICE_URL=${module.lambda_functions.payment_function_url}
NOTIFICATION_SERVICE_URL=${module.lambda_functions.notification_function_url}

PAYMENT_LAMBDA_ARN=${module.lambda_functions.payment_lambda_function_arn}
NOTIFICATION_LAMBDA_ARN=${module.lambda_functions.notification_lambda_function_arn}

SNS_TOPIC_ARN=${module.lambda_functions.sns_topic_arn}
EOT
}
