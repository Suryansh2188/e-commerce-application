variable "project_name" {
  description = "Project name"
  type        = string
  default     = "shopitry"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "EC2 key pair"
  type        = string
}

variable "instance_id" {
  description = "Control plan EC2 instance id"
  type = string
}

# variable "public_subnet_id" {
#   description = "Public subnet ID"
#   type        = string
# }

# variable "private_subnet_id" {
#   description = "Private subnet ID"
#   type        = string
# }

# variable "public_services_security_group_id" {
#   description = "Security group ID for public services"
#   type        = string
# }

# variable "private_services_security_group_id" {
#   description = "Security group ID for private services"
#   type        = string
# }

variable "services" {
  description = "EC2 microservices"

  type = map(object({
    name          = string
    folder        = string
    port          = number
    private_ip    = string
    public        = bool
  }))
}

variable "acm_certificate_arn" {
  type = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "user_bucket_name" {
  description = "User frontend S3 bucket"
  type        = string
}

variable "admin_bucket_name" {
  description = "Admin frontend S3 bucket"
  type        = string
}

variable "user_domain" {
  description = "User frontend domain"
  type        = string
  default     = "xyz.com"
}

variable "admin_domain" {
  description = "Admin frontend domain"
  type        = string
  default     = "admin.xyz.com"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)

  default = {
    Project   = "Frontend"
    ManagedBy = "Terraform"
  }
}