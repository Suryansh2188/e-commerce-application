resource "aws_iam_role" "lambda" {
  name = "ShopiTryLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role = aws_iam_role.lambda.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// Payment Lambda function

data "archive_file" "payment" {
  type        = "zip"
  source_dir  = "${path.root}/../backend/payment-service"
  output_path = "${path.module}/payment-service.zip"
}

resource "aws_lambda_function" "payment" {
  function_name = "shopitry-payment-service"

  runtime = "nodejs20.x"

  role = aws_iam_role.lambda.arn

  handler = "src/handler.handler"

  filename = data.archive_file.payment.output_path

  source_code_hash = data.archive_file.payment.output_base64sha256

  timeout = 30

  environment {
    variables = {
      PAYMENT_GATEWAY_MODE = "PRODUCTION"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]
}

resource "aws_lambda_function_url" "payment" {
  function_name      = aws_lambda_function.payment.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["*"]
  }
}

resource "aws_lambda_permission" "payment_function_url" {
  statement_id           = "AllowPublicFunctionURL"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.payment.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}



// Notification Lambda function

data "archive_file" "notification" {
  type        = "zip"
  source_dir  = "${path.root}/../backend/notification-service"
  output_path = "${path.module}/notification-service.zip"
}


resource "aws_sns_topic" "notifications" {
  name = "aethercart-notifications"
  region = var.aws_region
}

resource "aws_lambda_function" "notification" {
  function_name = "shopitry-notification-service"

  runtime = "nodejs20.x"

  role = aws_iam_role.lambda.arn

  handler = "src/handler.handler"

  filename = data.archive_file.notification.output_path

  source_code_hash = data.archive_file.notification.output_base64sha256

  timeout = 30

  depends_on = [
    aws_iam_role_policy_attachment.lambda_basic_execution
  ]
}

resource "aws_lambda_function_url" "notification" {
  function_name      = aws_lambda_function.notification.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = false
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["*"]
  }
}

resource "aws_lambda_permission" "notification_function_url" {
  statement_id           = "AllowPublicFunctionURL"
  action                 = "lambda:InvokeFunctionUrl"
  function_name          = aws_lambda_function.notification.function_name
  principal              = "*"
  function_url_auth_type = "NONE"
}