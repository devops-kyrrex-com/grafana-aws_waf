locals {
  block_ip = compact(split("\n", file("./out.txt")))
}

resource "aws_wafv2_ip_set" "blacklist-ip-sets" {
  name               = "blacklist-ip-sets"
  scope              = var.ip_set_scope
  ip_address_version = "IPV4"
  addresses          = local.block_ip
}

resource "aws_wafv2_regex_pattern_set" "blacklist-pattern" {
  name  = "blacklist-pattern"
  scope = var.ip_set_scope

  regular_expression {
    regex_string = "one"
  }
}

resource "aws_wafv2_rule_group" "blacklist-rule-group" {
  name        = "blacklist-rule-group"
  description = "An rule group containing all statements"
  scope       = var.ip_set_scope
  capacity    = 500

  rule {
    name     = "rule-1"
    priority = 1

    action {
      block {}
    }

    statement {

      or_statement {
        statement {

          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.blacklist-ip-sets.arn
          }
        }

        statement {

          regex_pattern_set_reference_statement {
            arn = aws_wafv2_regex_pattern_set.blacklist-pattern.arn

            field_to_match {
              single_header {
                name = "referer"
              }
            }

            text_transformation {
              priority = 2
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "rule-1"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }

  tags = {
    Name = "example-and-statement"
    Code = "123456"
  }
}

resource "aws_wafv2_web_acl" "blacklistweb-acl" {
  name  = "blacklistweb-acl"
  scope = var.ip_set_scope

  default_action {
    block {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      count {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.blacklist-rule-group.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "friendly-rule-metric-name"
      sampled_requests_enabled   = false
    }
  }

  tags = {
    Tag1 = "Value1"
    Tag2 = "Value2"
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "friendly-metric-name"
    sampled_requests_enabled   = false
  }
}