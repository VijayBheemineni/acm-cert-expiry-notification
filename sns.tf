resource "aws_sns_topic" "acm_expiration" {
  name = var.application_name
}

resource "aws_sns_topic_subscription" "acm_expiration_alert" {
  for_each = toset(var.acm_alert_email_list)

  topic_arn = aws_sns_topic.acm_expiration.arn
  protocol  = "email"
  endpoint  = each.value
}

