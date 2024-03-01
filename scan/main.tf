locals {
  lambda_src  = "${path.module}/src"
  handler     = "index.lambda_handler"
  runtime     = "python3.11"
  queue_name  = "${var.project_name}-ingestion-source-queue"
  role_name   = "${var.project_name}-ingestion-scan-role"
  lambda_name = "${var.project_name}-${var.lambda_name}"
  log_group   = "${var.project_name}-${var.lambda_name}"
}

resource "aws_sqs_queue" "scan_queue" {
  name = local.queue_name
}

data "aws_s3_bucket" "ingestion_source_storage" {
  bucket = var.raw_files_bucket
}

module "aws_lambda_function" {
  depends_on = [aws_sqs_queue.scan_queue, data.aws_s3_bucket.ingestion_source_storage]
  source     = "terraform-aws-modules/lambda/aws"

  # Lambda function details
  function_name = local.lambda_name
  description   = var.lambda_description
  handler       = local.handler

  # Execution details
  runtime     = local.runtime
  timeout     = var.timeout
  memory_size = var.memory_size
  environment_variables = {
    QUEUE_URL     = aws_sqs_queue.scan_queue.url
    SOURCE_BUCKET = var.raw_files_bucket
  }

  # Network details
  vpc_security_group_ids = var.security_group_ids
  vpc_subnet_ids         = var.subnet_ids

  # Deployment details
  source_path = local.lambda_src

  # IAM role
  create_role              = true
  role_name                = local.role_name
  attach_policy_statements = true
  policy_statements = {
    log_write = {
      effect = "Allow"

      resources = [
        "arn:aws:logs:${var.aws_region}:${var.account_id}:log-group:/aws/${local.log_group}/*:*"
      ]
      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
    }
    access_network_interface = {
      effect = "Allow"

      resources = [
        "*"
      ]

      actions = [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
      ]
    }

    sqs = {
      effect = "Allow"

      resources = [
        aws_sqs_queue.scan_queue.arn
      ]

      actions = [
        "sqs:SendMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
      ]
    }

    s3 = {
      effect = "Allow"
      resources = [
        data.aws_s3_bucket.ingestion_source_storage.arn,
        "${data.aws_s3_bucket.ingestion_source_storage.arn}/*"
      ]

      actions = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
    }
  }
}
