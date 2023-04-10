variable "api_gateway_name" {
  type    = string
  description = "The name of the API Gateway"
}

variable "aws_region" {
  description = "The AWS region"
  type    = string
  default = "us-east-1"
}

variable "function_name" {
  type    = string
  description = "The name of the Lambda function to be created"
}

variable "lambda_arn" {
  type    = string
  description = "The ARN of the Lambda function to be invoked by the API Gateway"
}