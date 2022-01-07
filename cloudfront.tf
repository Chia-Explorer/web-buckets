resource "aws_cloudfront_distribution" "this" {
  count = length(var.web_sites)

  origin {
    domain_name = aws_s3_bucket.web[count.index].bucket_regional_domain_name
    origin_id   = var.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.web_sites[count.index].subdomain]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cheapest option as we cache as Cloudflare anyway
  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.wildcard.arn
    ssl_support_method  = "sni-only"
  }

  # needed to ensure react manages routes when immediately browsing to a path other than the index
  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }

  # needed to ensure react manages routes when immediately browsing to a path other than the index
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }
}