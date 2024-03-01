output "lambda_name" {
  value = module.aws_lambda_function.lambda_function_name
}

output "log_group_name" {
  value = module.aws_lambda_function.lambda_cloudwatch_log_group_name
}

output "lambda_role_name" {
  value = module.aws_lambda_function.lambda_role_name
}

output "queue_name" {
  value = aws_sqs_queue.scan_queue.name
}
