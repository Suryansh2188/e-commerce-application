
variable "bucket_name" {
  description = "Globally unique S3 bucket name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default = ""
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
