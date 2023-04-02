output "lambda_arn" {
  value       = aws_lambda_function.main.arn
  description = "The ARN of the created Lambda function."
}