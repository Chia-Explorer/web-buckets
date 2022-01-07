provider "aws" {
  alias  = "acm"
  region = "us-east-1"
}

resource "aws_acm_certificate" "wildcard" {
  provider                  = aws.acm
  domain_name               = var.cloudflare_zone
  subject_alternative_names = ["*.${var.cloudflare_zone}"]
  validation_method         = "EMAIL"

  lifecycle {
    create_before_destroy = true
  }
}