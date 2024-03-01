data "aws_caller_identity" "current" {}

locals {
  storage_name = "ingestion-source-storage"
  lambda_name  = "ingestion-scan"
}

resource "aws_s3_bucket" "raw_files_storage" {
  bucket = "${var.project_name}-${local.storage_name}"
}

module "ingestion_scan" {
  depends_on       = [aws_s3_bucket.raw_files_storage]
  source           = "./scan"
  aws_region       = "us-east-1"
  account_id       = data.aws_caller_identity.current.account_id
  lambda_name      = local.lambda_name
  timeout          = 60
  memory_size      = 128
  raw_files_bucket = aws_s3_bucket.raw_files_storage.bucket
  project_name     = var.project_name
}
