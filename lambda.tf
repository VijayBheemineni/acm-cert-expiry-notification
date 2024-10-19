resource "aws_lambda_function" "acm_expiration_sns" {
  function_name = var.application_name
  handler       = var.lambda_handler_name # The Python handler
  runtime       = var.lambda_runtime      # Python version
  role          = aws_iam_role.lambda_execution_role.arn

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.acm_expiration.arn
    }
  }
}
