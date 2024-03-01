variable "aws_region" {
  description = "The AWS region"
  type        = string
  nullable    = false
}

variable "account_id" {
  description = "The AWS account ID"
  type        = string
  nullable    = false
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  nullable    = false
}

variable "lambda_name" {
  description = "The name of the Lambda function"
  type        = string
  nullable    = false
  validation {
    condition     = length(var.lambda_name) > 0
    error_message = "The Lambda function name cannot be empty"
  }
}

variable "lambda_description" {
  description = "The description of the Lambda function"
  type        = string
  nullable    = true
  default     = null
}

## Network details
variable "subnet_ids" {
  description = "The subnet IDs for the Lambda function"
  type        = list(string)
  nullable    = true
  default     = null
}

variable "security_group_ids" {
  description = "The security group IDs for the Lambda function"
  type        = list(string)
  nullable    = true
  default     = null
}

## Execution details
variable "timeout" {
  description = "The timeout for the Lambda function"
  type        = number
  default     = 60
}

variable "memory_size" {
  description = "The memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "raw_files_bucket" {
  description = "The name of the S3 bucket where the raw files are stored"
  type        = string
  nullable    = false
}
