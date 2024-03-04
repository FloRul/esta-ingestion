variable "project_name" {
  description = "The name of the project"
  type        = string
  nullable    = false
  default     = ""
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  nullable    = false
  default     = "us-east-1"
}

## source_storage
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  nullable    = false
  default     = ""
}

variable "notification_filter_prefix" {
  description = "The file extension to filter for notifications"
  type        = string
  nullable    = true
  default     = ".pdf"
}
