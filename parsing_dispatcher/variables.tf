variable "project_name" {
  nullable = false
  type     = string
}

variable "ingestion_queue_arn" {
  nullable = false
  type     = string
}

variable "lambda_storage_bucket" {
  nullable = false
  type     = string
}

variable "pdf_parsing_lambda_name" {
  nullable = false
  type     = string
}

variable "aws_region" {
  nullable = false
  type     = string
}

variable "account_id" {
  nullable = false
  type     = string
}
