variable "project_name" {
  description = "The name of the project"
  type        = string
  nullable    = false
}

variable "bucket_name" {
  nullable    = false
  description = "The name of the S3 bucket"
  type        = string
}

variable "notification_filter_prefix" {
  nullable    = true
  description = "The file extension to filter for notifications"
  type        = string
  default     = ".pdf"
}

variable "ingestion_queue_name" {
  nullable    = false
  description = "The name of the SQS queue where the ingestion process will send notifications"
  type        = string
}
