terraform {
  backend "s3" {
    bucket  = "gpt-blog-remotestate-backend-s3-dev"
    key     = "tfstate/environments/development/lambda/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

provider "aws" {
  region = "us-west-2"
}

# IAM
resource "aws_iam_role" "role" {
  name = "myrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}


module "lambda" {
  source        = "./lambda"
  function_name = "main"
  role          = aws_iam_role.role.arn
  handler       = "main"
  runtime       = "go1.x"
  zip_file      = "./build/main.zip"
  accountId     = var.accountId
  http_method   = module.api_gateway.http_method
  path          = module.api_gateway.path
  rest_api      = module.api_gateway.rest_api
}

module "api_gateway" {
  source               = "./api_gateway"
  name                 = "gpt-blog-api"
  lambda_arn           = module.lambda.lambda_arn
  lambda_function_name = "main"
  invoke_arn           = module.lambda.invoke_arn 
}
