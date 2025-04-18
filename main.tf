provider "aws" {
  region = var.region
}

resource "aws_iam_role" "lambda_exec_role" {
  name               = "LambdaECSRestartRole"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "ecs_restart_policy" {
  name = "lambda-ecs-restart"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "eb_scheduler_exec_role" {
  name               = "EventBridge_Scheduler_Lambda_ECS_Restart"
  assume_role_policy = data.aws_iam_policy_document.eb_scheduler_assume_role.json
}

data "aws_iam_policy_document" "eb_scheduler_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["scheduler.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "eb_scheduler_policy" {
  name = "Amazon-EventBridge-Scheduler-Execution-Policy-for-ecs-restart-lambda"
  role = aws_iam_role.eb_scheduler_exec_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "lambda:InvokeFunction"
        ],
        "Resource": [
          "arn:aws:lambda:${var.region}::function:${var.lambda_name}:*",
          "arn:aws:lambda:${var.region}::function:${var.lambda_name}"
        ]
      }
    ]
  })
}


