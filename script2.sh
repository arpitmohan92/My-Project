provider "aws" {
  region = "your-region"
}

# Create an ECS Task Restart Lambda Function
resource "aws_lambda_function" "ecs_restart_lambda" {
  filename      = "ecs_restart.zip"  # Path to your Lambda deployment package
  function_name = "ecsRestartFunction"
  handler       = "ecs_restart.sh"   # Name of your script
  runtime       = "provided"
  role          = aws_iam_role.lambda_execution_role.arn
}

# Create an IAM role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach necessary policies to Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
  role       = aws_iam_role.lambda_execution_role.name
}

# Create CloudWatch Events Rule
resource "aws_cloudwatch_event_rule" "ecs_restart_rule" {
  name                = "ECSRestartRule"
  schedule_expression = "cron(0 0 * * ? *)"  # Example: daily at midnight UTC
}

# Add Lambda function as a target for the CloudWatch Events Rule
resource "aws_cloudwatch_event_target" "ecs_restart_target" {
  rule      = aws_cloudwatch_event_rule.ecs_restart_rule.name
  target_id = "ecsRestartTarget"
  arn       = aws_lambda_function.ecs_restart_lambda.arn
}
