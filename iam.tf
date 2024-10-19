# Lambda Execution Role
resource "aws_iam_role" "lambda_execution_role" {
  name = var.application_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "lambda_sns" {
  name = join("-", [var.application_name, "lambda-sns"])
  role = aws_iam_role.lambda_execution_role.id
  policy = templatefile("${path.module}/templates/sns.json", {
    SNS_TOPIC_ARN = aws_sns_topic.acm_expiration.arn
  })
}

resource "aws_iam_role_policy_attachment" "lambda_cloudwatchlogs_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}
