output "payment_lambda_function_name" {
  value = aws_lambda_function.payment.function_name
}

output "payment_lambda_function_arn" {
  value = aws_lambda_function.payment.arn
}

output "payment_function_url" {
  value = aws_lambda_function_url.payment.function_url
}

output "notification_lambda_function_name" {
  value = aws_lambda_function.notification.function_name
}

output "notification_lambda_function_arn" {
  value = aws_lambda_function.notification.arn
}

output "notification_function_url" {
  value = aws_lambda_function_url.notification.function_url
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda.arn
}


output "sns_topic_arn" {
  value = aws_sns_topic.notifications.arn
}

output "sns_topic_name" {
  value = aws_sns_topic.notifications.name
}