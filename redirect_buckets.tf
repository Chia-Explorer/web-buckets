resource "aws_s3_bucket" "redirect" {
  count = length(var.redirects)

  bucket = var.redirects[count.index].subdomain
  acl    = "public-read"

  website {
    redirect_all_requests_to = var.redirects[count.index].redirect_url
  }

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allow",
        "Principal": "*",
        "Action": ["s3:GetObject"],
        "Resource": ["arn:aws:s3:::${var.redirects[count.index].subdomain}/*"]
    }]
}
EOT
}
