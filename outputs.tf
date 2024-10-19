output "event_bus_rule_name" {
  description = "Event Bus Rule Name"
  value       = aws_cloudwatch_event_rule.acm_expiration_rule.name
}

output "lambda_acm_expiration_function_name" {
  description = "Lambda ACM Expiration Function Name"
  value       = aws_lambda_function.acm_expiration_sns.function_name
}

output "sns_topic_arn" {
  description = "SNS Topic ARN"
  value       = aws_sns_topic.acm_expiration.arn
}
