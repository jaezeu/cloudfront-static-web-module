resource "aws_wafv2_web_acl" "cloudfront" {
  #checkov:skip=CKV2_AWS_31:Ensure WAF2 has a Logging Configuration
  #checkov:skip=CKV_AWS_192:Ensure WAF prevents message lookup in Log4j2. See CVE-2021-44228 aka log4jshell
  name  = "jaz-cloudfront-waf-${var.env}"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "jaz-cloudfront-waf-${var.env}-metrics"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "jaz-CommonRuleSet-${var.env}"
    priority = 0
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "jaz-CommonRuleSet-${var.env}"
      sampled_requests_enabled   = true
    }
  }
}