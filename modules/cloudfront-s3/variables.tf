variable "prefix" {
  type = string
  default = "jaz"
}

variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
  description = "Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or your custom origin."
}

variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
  description = "Controls whether CloudFront caches the response to requests using the specified HTTP methods."
}

variable "viewer_protocol_policy" {
  type    = string
  default = "allow-all"
  description = "One of allow-all, https-only, or redirect-to-https."
}

variable "web_acl_id" {
  type    = string
  default = ""
  description = "Unique identifier that specifies the AWS WAF web ACL, if any, to associate with this distribution."
}