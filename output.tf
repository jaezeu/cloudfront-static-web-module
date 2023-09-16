output "domain" {
  value = module.static_web_stack.cloudfront_domain
}

output "id" {
  value = module.static_web_stack.cloudfront_id
}

output "bucket_name" {
  value = module.static_web_stack.bucket_name
}