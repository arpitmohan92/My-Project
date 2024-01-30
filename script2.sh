# AWS Lambda Function
resource "aws_lambda_function" "ecs_service_restart" {
  function_name = "ECS-Service-Restart"
  filename      = "lambda_function.zip"  # Specify the path to your Lambda function code
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  timeout       = 60
  role          = aws_iam_role.lambda_execution_role.arn
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda Execution
resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda execution role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        Resource = [
          "arn:aws:ecs:YOUR_REGION:YOUR_ACCOUNT_ID:service/YOUR_CLUSTER/YOUR_SERVICE",
          # Add more service ARNs if needed
        ],
        Condition = {
          ArnEquals = {
            "ecs:cluster": "arn:aws:ecs:YOUR_REGION:YOUR_ACCOUNT_ID:cluster/YOUR_CLUSTER"
          }
        }
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_execution_attachment" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

# EventBridge Rule - Trigger Lambda at 7 am and 4 pm daily
resource "aws_cloudwatch_event_rule" "daily_schedule_rule" {
  name                = "daily_schedule_rule"
  description         = "Rule to trigger Lambda function daily"
  schedule_expression = "cron(0 7,16 * * ? *)"  # Schedule to run at 7 am and 4 pm

  event_pattern = jsonencode({
    source = ["aws.events"],
    detail = {
      eventName = ["EcsServiceRestartEvent"]
    }
  })
}

# EventBridge Rule Target to invoke Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.daily_schedule_rule.name
  target_id = "invoke_lambda_function"

  arn = aws_lambda_function.ecs_service_restart.arn
}
