output "domain" {
  value = module.static_web_stack.cloudfront_domain
}

output "bucket_name" {
  value = module.static_web_stack.bucket_name
}