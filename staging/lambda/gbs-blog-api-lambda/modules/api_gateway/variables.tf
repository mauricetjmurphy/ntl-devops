variable "api_gateway_name" {
  type    = string
}

variable "lambda_arn" {
  type    = string
}

variable "function_name" {
  type    = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}