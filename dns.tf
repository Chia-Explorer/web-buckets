data "cloudflare_zone" "this" {
  name = var.cloudflare_zone
}

resource "cloudflare_record" "web" {
  count = length(var.web_sites)

  zone_id = data.cloudflare_zone.this.id
  type    = "CNAME"
  name    = var.web_sites[count.index].dns_name
  value   = aws_cloudfront_distribution.this[count.index].domain_name
  ttl     = var.web_sites[count.index].dns_ttl
  proxied = var.web_sites[count.index].proxied
}

resource "cloudflare_record" "redirect" {
  count = length(var.redirects)

  zone_id = data.cloudflare_zone.this.id
  type    = "CNAME"
  name    = var.redirects[count.index].dns_name
  value   = aws_s3_bucket.web[count.index].website_endpoint
  ttl     = var.redirects[count.index].dns_ttl
  proxied = var.redirects[count.index].proxied
}
