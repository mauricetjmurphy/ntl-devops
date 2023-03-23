terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-dev"
    key     = "tfstate/environments/development/cloudfront/gbs-blog-articles-green-tech/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

module "cloudfront" {
  # source                = "git@github.com:mauricetjmurphy/Terraform-Modules.git//cloudfront"
  source                = "./cloudfront"
  environment           = var.environment
  bucket_name           = var.static_libs_s3_bucket_name
}