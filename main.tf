module "static_web_stack" {
  source = "./modules/cloudfront-s3"

  prefix = local.resource_prefix
  web_acl_id = module.waf.web_acl_arn
}

module "waf" {
  source = "umotif-public/waf-webaclv2/aws"
  version = "5.1.2"

  providers = {
    aws = aws.us-east-1
  }

  name_prefix = "${local.resource_prefix}-cf-waf"
  scope = "CLOUDFRONT"

  create_alb_association = false

  visibility_config = {
    metric_name = "${local.resource_prefix}-cf-waf-main-metrics"
  }

  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        metric_name                = "${local.resource_prefix}-AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    },
  ]
}