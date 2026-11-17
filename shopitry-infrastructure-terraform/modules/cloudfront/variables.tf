
variable "application_name" {
  description = "Application name"
  type        = string
}

variable "domain_name" {
  description = "Frontend domain name"
  type        = string
}

variable "s3_bucket_id" {
  description = "S3 bucket name"
  type        = string
}

variable "s3_bucket_arn" {
  description = "S3 bucket ARN"
  type        = string
}

variable "s3_bucket_regional_domain_name" {
  description = "S3 bucket regional domain"
  type        = string
}

variable "acm_certificate_arn" {
  description = "Existing ACM certificate ARN in us-east-1"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default = ""
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
