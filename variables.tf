variable "project_name" {
  description = "Name prefix for all AWS resources"
  type        = string
}
variable "lambda_name" {
  description = "Name of the lambda function"
  type        = string
  default = "ecs-rolling-restart"
}
variable "environment" {
  description = "Environment name (dev, prod, etc.)"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "lambda_schedule_expression" {
  description = "EventBridge cron expression (UTC)"
  type        = string
  default     = "cron(1 5 * * ? *)" # 12:01 AM EST
}

/*
variable "ecs_services" {
  description = "List of maps containing ECS cluster and service names"
  type = list(object({
    cluster = string
    service = string
  }))
}*/
