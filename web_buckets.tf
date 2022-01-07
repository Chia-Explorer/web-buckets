resource "aws_s3_bucket" "web" {
  count = length(var.web_sites)

  bucket = var.web_sites[count.index].subdomain
  acl    = "public-read"

  versioning {
    enabled = var.web_sites[count.index].versioning_enabled
  }

  website {
    index_document = var.web_sites[count.index].index_document
    error_document = var.web_sites[count.index].error_document
    routing_rules = <<EOF
[{
    "Condition": {
        "HttpErrorCodeReturnedEquals": "404"
    },
    "Redirect": {
        "HostName": "${var.web_sites[count.index].subdomain}"
    }
}, {
    "Condition": {
        "HttpErrorCodeReturnedEquals": "403"
    },
    "Redirect": {
        "HostName": "${var.web_sites[count.index].subdomain}"
    }
}]
EOF
  }

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "PublicReadForGetBucketObjects",
        "Effect": "Allow",
        "Principal": "*",
        "Action": ["s3:GetObject"],
        "Resource": ["arn:aws:s3:::${var.web_sites[count.index].subdomain}/*"]
    }]
}
EOT
}
