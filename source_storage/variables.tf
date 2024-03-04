variable "project_name" {
  description = "The name of the project"
  type        = string
  nullable    = false
}

variable "notification_filter_prefix" {
  nullable    = true
  description = "The file extension to filter for notifications"
  type        = string
  default     = ".pdf"
}
