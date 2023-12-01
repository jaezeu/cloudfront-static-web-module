module "static_web_stack" {
  source = "./modules/cloudfront-s3"

  prefix = local.resource_prefix
  web_acl_id = module.waf.web_acl_arn
  acm_certificate_arn = module.acm.acm_certificate_arn
  aliases = ["jaz-tf.sctp-sandbox.com"]
}
#
module "waf" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
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

module "acm" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  providers = {
    aws = aws.us-east-1
  }

  domain_name  = "jaz-tf.sctp-sandbox.com"
  zone_id      = "Z00541411T1NGPV97B5C0"
  
  validation_method = "DNS"

  subject_alternative_names = [
    "*.jaz-tf.sctp-sandbox.com",
  ]
}

module "records" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = "sctp-sandbox.com"

  records = [
    {
      name    = "jaz-tf"
      type    = "A"
      alias   = {
        name    = "${module.static_web_stack.cloudfront_domain}"
        zone_id = "Z2FDTNDATAQYW2"
      }
    },
  ]
}