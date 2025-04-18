resource "aws_lambda_function" "ecs_restart" {
  filename         = "${path.module}/lambda/ecs_restart_lambda.zip"
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "ecs_restart_lambda.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("${path.module}/lambda/ecs_restart_lambda.zip")
  timeout          = 30

  environment {
    variables = {
      LOG_LEVEL = "INFO"
    }
  }
}
