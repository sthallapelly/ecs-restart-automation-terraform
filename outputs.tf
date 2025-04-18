output "lambda_function_name" {
  value = aws_lambda_function.ecs_restart.function_name
}

output "eventbridge_schedule_name" {
  value = aws_scheduler_schedule.ecs_restart.name
}
