locals {
  env_vars = merge(
    jsondecode(file("./.env")),
    {
      // Add any additional environment variables here
    }
  )
}

resource "aws_lambda_function" "main" {
  function_name = var.function_name
  s3_bucket     = var.bucket_id
  s3_key        = "main.zip"
  runtime       = "nodejs18.x"
  handler       = "lambda.handler"
  role          = var.iam_role_arn

  environment {
    variables = local.env_vars
  }

}

resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/lambda/${aws_lambda_function.main.function_name}"

  retention_in_days = 14
}

# data "archive_file" "main" {
#   type = "zip"

#   source_dir  = "../${path.module}/main"
#   output_path = "../${path.module}/main.zip"
# }

# resource "aws_s3_object" "main" {
#   bucket = aws_s3_bucket.lambda_bucket.id

#   key    = "main.zip"
#   source = data.archive_file.lambda_hello.output_path

#   etag = filemd5(data.archive_file.lambda_hello.output_path)
# }