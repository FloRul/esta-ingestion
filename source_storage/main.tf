locals {
  queue_name  = "${var.project_name}-${var.ingestion_queue_name}"
  bucket_name = "${var.project_name}-${var.bucket_name}"
}

module "source_storage" {
  source = "terraform-aws-modules/s3-bucket/aws"
  bucket = local.bucket_name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

resource "aws_sqs_queue" "source_ingestion" {
  name = local.queue_name
}

resource "aws_s3_bucket_notification" "ingestion_notification" {
  bucket = module.source_storage.s3_bucket_id

  queue {
    queue_arn     = aws_sqs_queue.source_ingestion.arn
    events        = ["s3:ObjectCreated:*, s3:ObjectRemoved:*"]
    filter_suffix = var.notification_filter_prefix
  }
}
