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

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone" {
  description = "Availability zone"
  type        = string
  default     = "ap-south-1a"
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