locals {
  origin_id = "s3origin"
}

resource "aws_s3_bucket" "static_web" {
  bucket = "${var.prefix}-s3-bkt"
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.static_web.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.origin_id
  }

  enabled             = true
  comment             = "Static Website using S3 and Cloudfront OAC"
  default_root_object = "index.html"
  web_acl_id = var.web_acl_id

  default_cache_behavior {
    cache_policy_id        = data.aws_cloudfront_cache_policy.example.id
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = local.origin_id
    viewer_protocol_policy = var.viewer_protocol_policy
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "${aws_s3_bucket.static_web.id}-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}