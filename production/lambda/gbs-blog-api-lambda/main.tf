terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-prod"
    key     = "tfstate/environments/production/content-api-lambda/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "iam" {
  source          = "./modules/iam"
  function_name   = var.function_name
  iam_role_name   = var.iam_role_name
  api_gateway_arn = "${module.api_gateway.api_gateway_arn}"
  iam_role_arn    = "${module.iam.iam_role_arn}"
  lambda_arn      = "${module.lambda.lambda_arn}"
}

module "lambda" {
  source       = "./modules/lambda"
  function_name = var.function_name
  iam_role_arn = "${module.iam.iam_role_arn}"
  lambda_arn   = "${module.lambda.lambda_arn}"
  bucket_id    = "${module.s3.bucket_id}"
}

module "api_gateway" {
  source           = "./modules/api_gateway"
  function_name    = var.function_name
  api_gateway_name = var.api_gateway_name
  lambda_arn       = "${module.lambda.lambda_arn}"
}

module "s3" {
  source           = "./modules/s3"
  bucket_name      = var.bucket_name
}