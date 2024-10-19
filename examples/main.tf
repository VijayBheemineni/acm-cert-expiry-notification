module "acm_expiration_notification" {
  source               = "../"
  application_name     = var.application_name
  acm_alert_email_list = var.acm_alert_email_list
}
