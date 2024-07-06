data "aws_acm_certificate" "certificate" {
  domain   = local.domain_name
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "hosted_zone" {
  name         = local.domain_name
  private_zone = false
}