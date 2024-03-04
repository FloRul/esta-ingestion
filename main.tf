data "aws_caller_identity" "current" {}

locals {
  storage_name = "ingestion-source-storage"
  lambda_name  = "ingestion-scan"
}

module "source_storage" {
  source                     = "./source_storage"
  project_name               = var.project_name
  notification_filter_prefix = var.notification_filter_prefix
  aws_region                 = var.aws_region
  account_id                 = data.aws_caller_identity.current.account_id
}

module "parsing_dispatcher" {
  source                  = "./parsing_dispatcher"
  project_name            = var.project_name
  lambda_storage_bucket   = aws_s3_bucket.lambda_storage.bucket
  pdf_parsing_lambda_name = "pdf_parsing_lambda_mock"
  aws_region              = var.aws_region
  account_id              = data.aws_caller_identity.current.account_id
  ingestion_queue_arn = module.source_storage.ingestion_queue_arn
}

