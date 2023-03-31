terraform {
  backend "s3" {
    bucket  = "gbs-blog-remotestate-backend-s3-prod"
    key     = "tfstate/environments/production/cloudfront/gbs-blog-article-images/terraform.tfstate"
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