output "api_gateway_arn" {
  value       = aws_api_gateway_deployment.main.execution_arn
  description = "The ARN of the created API Gateway REST API."
}

output "base_url" {
  value = "${aws_api_gateway_deployment.main.invoke_url}"
}

