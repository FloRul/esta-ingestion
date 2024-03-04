data "aws_caller_identity" "current" {}

locals {
  storage_name = "ingestion-source-storage"
  lambda_name  = "ingestion-scan"
}

module "source_storage" {
  source                     = "./source_storage"
  project_name               = var.project_name
  notification_filter_prefix = var.notification_filter_prefix
}

module "parsing_dispatcher" {
  source = "./parsing_dispatcher"
  project_name = var.project_name
  lambda_storage_bucket = aws_s3_bucket.lambda_storage.bucket
  pdf_parsing_lambda_name = aws_lambda_function.pdf_parsing_lambda.function_name
  aws_region = var.aws_region
  account_id = data.aws_caller_identity.current.account_id
}

# module "ingestion_scan" {
#   depends_on       = [aws_s3_bucket.raw_files_storage]
#   source           = "./scan"
#   aws_region       = "us-east-1"
#   account_id       = data.aws_caller_identity.current.account_id
#   lambda_name      = local.lambda_name
#   timeout          = 60
#   memory_size      = 128
#   raw_files_bucket = aws_s3_bucket.raw_files_storage.bucket
#   project_name     = var.project_name
# }
