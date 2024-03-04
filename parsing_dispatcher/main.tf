locals {
  lambda_name = "${var.project_name}-parsing-dispatcher"
  handler     = "index.lambda_handler"
  runtime     = "python3.11"
}

module "parsing_dispatcher" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = local.lambda_name
  handler       = local.handler
  runtime       = local.runtime
  publish       = true

  source_path = "${path.module}/src"

  store_on_s3 = true
  s3_bucket   = var.lambda_storage_bucket

  environment_variables = {
    LAMBDA_MAPPING = jsonencode({
      ".pdf" = var.pdf_parsing_lambda_name,
      # ".docx" = var.docx_parsing_lambda_name,
      # ".xlsx" = var.xlsx_parsing_lambda_name,
      # etc ...
    })
  }

  attach_policy_statements = true
  policy_statements = {
    log_group = {
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup"
      ]
      resources = [
        "arn:aws:logs:*:*:*"
      ]
    }
    log_write = {
      effect = "Allow"

      resources = [
        "arn:aws:logs:*:*:log-group:/aws/${local.lambda_name}/*:*"
      ]

      actions = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
      ]
    }
    lambda_invoke = {
      effect = "Allow"
      actions = [
        "lambda:InvokeFunction"
      ]
      resources = [
        "arn:aws:lambda:${var.aws_region}:${var.account_id}:${var.pdf_parsing_lambda_name}"
      ]
    }
  }
}

resource "aws_lambda_event_source_mapping" "ingestion_queue_trigger" {
  depends_on = [ module.parsing_dispatcher ]
  event_source_arn = aws_sqs_queue.queue.arn
  enabled          = true
  function_name    = module.parsing_dispatcher.function_name
  batch_size       = 10
}
