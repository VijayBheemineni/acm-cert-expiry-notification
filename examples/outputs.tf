output "event_bus_rule_name" {
  description = "Event Bus Rule Name"
  value       = module.acm_expiration_notification.event_bus_rule_name
}

output "lambda_acm_expiration_function_name" {
  description = "Lambda ACM Expiration Function Name"
  value       = module.acm_expiration_notification.lambda_acm_expiration_function_name
}

output "sns_topic_arn" {
  description = "SNS Topic ARN"
  value       = module.acm_expiration_notification.sns_topic_arn
}
