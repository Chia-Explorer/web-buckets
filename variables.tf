variable "region" {
  type        = string
  description = "AWS region to deploy infra into"
}

variable "cloudflare_zone" {
  type        = string
  description = "Zone to create in CloudFlare"
}

variable "cloudflare_api_token" {
  type        = string
  description = "API token for Cloudflare API"
}

variable "web_sites" {
  type        = list(object({ subdomain = string, versioning_enabled = bool, index_document = string, error_document = string, dns_name = string, dns_ttl = number, proxied = bool }))
  description = "Web sites to be hosted in S3 with DNS record in Cloudflare"
}

variable "redirects" {
  type        = list(object({ subdomain = string, redirect_url = string, dns_name = string, dns_ttl = number, proxied = bool }))
  description = "Web sites to be hosted in S3 with DNS record in Cloudflare"
}
