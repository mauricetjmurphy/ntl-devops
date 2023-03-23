# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.region}:${var.accountId}:${var.rest_api}/*/${var.http_method}${var.path}"
}

resource "aws_lambda_function" "lambda" {
  filename      = var.zip_file
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime

  source_code_hash = filebase64sha256("./build/main.zip")
}

# resource "aws_lambda_function" "lambda" {
#   function_name = var.function_name
#   role          = var.role
#   handler       = var.handler
#   runtime       = var.runtime
#   filename      = var.zip_file
# }

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}

output "invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}
