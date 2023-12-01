locals {
  origin_id = "s3origin"
}

resource "aws_s3_bucket" "static_web" {
  #checkov:skip=CKV_AWS_18:Ensure the S3 bucket has access logging enabled
  #checkov:skip=CKV2_AWS_61:Ensure that an S3 bucket has a lifecycle configuration
  #checkov:skip=CKV2_AWS_62:Ensure S3 buckets should have event notifications enabled
  #checkov:skip=CKV_AWS_145:Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV2_AWS_6:Ensure that S3 bucket has a Public Access block
  #checkov:skip=CKV_AWS_144:Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_21:Ensure all data stored in the S3 bucket have versioning enabled
  bucket = "${var.prefix}-s3-bkt"
}

resource "aws_s3_bucket_policy" "allow_access_from_cloudfront" {
  bucket = aws_s3_bucket.static_web.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  #checkov:skip=CKV_AWS_86:Ensure Cloudfront distribution has Access Logging enabled
  #checkov:skip=CKV_AWS_310:Ensure CloudFront distributions should have origin failover configured
  #checkov:skip=CKV_AWS_174:Verify CloudFront Distribution Viewer Certificate is using TLS v1.2
  #checkov:skip=CKV_AWS_34:Ensure cloudfront distribution ViewerProtocolPolicy is set to HTTPS
  #checkov:skip=CKV2_AWS_32:Ensure CloudFront distribution has a response headers policy attached
  #checkov:skip=CKV2_AWS_47:Ensure AWS CloudFront attached WAFv2 WebACL is configured with AMR for Log4j Vulnerability
  #checkov:skip=CKV2_AWS_42:Ensure AWS CloudFront distribution uses custom SSL certificate
  origin {
    domain_name              = aws_s3_bucket.static_web.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = local.origin_id
  }

  aliases = var.aliases

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
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method = "sni-only"
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