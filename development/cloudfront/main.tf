provider "aws" {
  region = local.region
}

terraform {
  backend "s3" {
    bucket  = "gemtech-remotestate-dev"
    key     = "ntl/cloudfront/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "default"
  }
}

locals {
  region      = "us-east-1"
  name        = "ntl"
  environment = "dev"
  domain_name = "nevertoolate.world"
}

module "s3_bucket" {
  source  = "git@github.com:mauricetjmurphy/gemtech-terraform-modules.git//s3"
  name                    = "${local.name}-bucket-cdn"
  environment             = local.environment
  versioning              = true
  acl                     = "private"
  bucket_policy           = true
  aws_iam_policy_document = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_origin_access_identity" "cloudfront" {
  comment = "CloudFront Origin Access Identity for ${local.name}-${local.environment}"
}

data "aws_iam_policy_document" "s3_policy" {
  version = "2012-10-17"
  statement {
    sid    = "1"
    effect = "Allow"
    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront.s3_canonical_user_id]
    }
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.arn}/*"]
  }
}

module "cdn" {
  source                 = "git::ssh://git@github.com/mauricetjmurphy/gemtech-terraform-modules.git//cloudfront"
  name                   = local.name
  environment            = local.environment
  enabled_bucket         = true
  compress               = false
  aliases                = [local.domain_name]
  bucket_name            = module.s3_bucket.id
  viewer_protocol_policy = "redirect-to-https"
  allowed_methods        = ["GET", "HEAD"]
  acm_certificate_arn    = data.aws_acm_certificate.certificate.arn
  origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront.cloudfront_access_identity_path
}

resource "aws_route53_record" "root_domain" {
  zone_id         = data.aws_route53_zone.hosted_zone.id
  name            = local.domain_name
  type            = "A"
  allow_overwrite = true
  alias {
    name                   = replace(module.cdn.domain_name, "/[.]$/", "")
    zone_id                = module.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}