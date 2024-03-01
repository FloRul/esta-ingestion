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
