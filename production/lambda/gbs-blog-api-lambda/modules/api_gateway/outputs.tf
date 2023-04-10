output "api_gateway_arn" {
  value       = aws_api_gateway_deployment.main.execution_arn
  description = "The ARN of the created API Gateway REST API."
}

output "base_url" {
  value = "${aws_api_gateway_deployment.main.invoke_url}"
}

output "api_gateway_invoke_url" {
value = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${var.aws_region}.amazonaws.com/prod"
}
