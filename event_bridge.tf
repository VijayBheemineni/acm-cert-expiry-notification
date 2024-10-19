resource "aws_cloudwatch_event_rule" "acm_expiration_rule" {
  name        = var.application_name
  description = "Rule to match ACM Certificate Approaching Expiration events"
  event_pattern = jsonencode({
    source        = ["aws.acm"],
    "detail-type" = ["ACM Certificate Approaching Expiration"]
  })
}

resource "aws_cloudwatch_event_target" "lambda_acm_expiration_sns" {
  rule      = aws_cloudwatch_event_rule.acm_expiration_rule.name
  target_id = "LambdaACMExpirationSNS"
  arn       = aws_lambda_function.acm_expiration_sns.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.acm_expiration_sns.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.acm_expiration_rule.arn
}
