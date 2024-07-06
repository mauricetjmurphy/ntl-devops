data "aws_acm_certificate" "portal_issued" {
  domain   = var.acm_certificate
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "portal_selected" {
  name         = var.acm_certificate
  private_zone = false
}