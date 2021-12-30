# Web buckets

This Terraform module creates s3 buckets that host web content and Cloudflare DNS records that point at the s3 buckets.

It is assumed that TLS will be handled by Cloudflare which is much simpler than managing certificates and DNS records in AWS. (having to create certs in ACM, verify identity, etc)

## Example usage

```
module "ui" {
  source = "git::https://github.com/Chia-Explorer/web-buckets?ref=1.0.0"

  region = var.region

  cloudflare_api_token = var.cloudflare_api_token
  cloudflare_zone      = var.cloudflare_zone

  web_sites = [{
    subdomain          = "www.chiaexplorer.com"
    versioning_enabled = true
    index_document     = "index.html"
    error_document     = "index.html"
    dns_name           = "www"
    dns_ttl            = 3600
  }]

  redirects = [{
    subdomain    = "chiaexplorer.com"
    redirect_url = "www.chiaexplorer.com"
    dns_name     = "@"
    dns_ttl      = 3600
  }]
}
```
