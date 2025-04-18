resource "aws_scheduler_schedule" "ecs_restart" {
  name       = "ecs-restart-scheduler"
  group_name = "default"
  flexible_time_window {
    mode = "OFF"
  }
  schedule_expression_timezone = "America/New_York"

  schedule_expression = var.lambda_schedule_expression

  target {
    arn      = aws_lambda_function.ecs_restart.arn
    role_arn = aws_iam_role.eb_scheduler_exec_role.arn

    input = file("${path.module}/config/scheduler_input.json")
  }
}

