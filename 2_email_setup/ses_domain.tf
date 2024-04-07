resource "aws_ses_domain_identity" "domains" {
  for_each = var.ses_domains
  domain   = each.key
}

resource "aws_ses_domain_dkim" "domains" {
  for_each = var.ses_domains
  domain   = aws_ses_domain_identity.domains[each.key].domain
}

data "cloudflare_zone" "dns_zone" {
  for_each = var.ses_domains
  name     = each.key
}

locals {
  dkim_tokens = flatten([for domain in aws_ses_domain_dkim.domains : [
    for token in domain.dkim_tokens : {
      "domain" = domain.domain
      "token"  = token
    }
    ]
  ])
}

#TODO: If aws_ses_domain_dkim.domains doesn't exist, count will be until to determine a plan 
# Current workaround is to target apply aws_ses_domain_dkim.domains first.
resource "cloudflare_record" "dkim_records" {
  count   = length(local.dkim_tokens)
  zone_id = data.cloudflare_zone.dns_zone[local.dkim_tokens[count.index].domain].id
  name    = "${local.dkim_tokens[count.index].token}._domainkey"
  value   = "${local.dkim_tokens[count.index].token}.dkim.amazonses.com"
  type    = "CNAME"
  ttl     = 300
  comment = "AWS SES - ${local.dkim_tokens[count.index].domain} - Managed by OpenTofu"
}

resource "aws_ses_receipt_rule_set" "receiving_rulesets" {
  rule_set_name = "default_ruleset"
}

resource "aws_ses_active_receipt_rule_set" "enable_ruleset" {
  rule_set_name = aws_ses_receipt_rule_set.receiving_rulesets.id
}

resource "aws_ses_receipt_rule" "email_ingress" {
  depends_on    = [aws_s3_bucket_policy.allow_ses_to_rw_to_s3]
  for_each      = var.ses_domains
  name          = "${each.key}-ingress"
  rule_set_name = aws_ses_receipt_rule_set.receiving_rulesets.id
  recipients    = [each.key]
  enabled       = true
  scan_enabled  = false

  s3_action {
    bucket_name = aws_s3_bucket.domain_mailboxes[each.key].id
    object_key_prefix = "ingress/"
    position = 1
  }

  stop_action {
    scope = "RuleSet"
    position = 2
  }
}

resource "aws_ses_receipt_rule" "bounce_fallback" {
  depends_on = [aws_ses_receipt_rule.email_ingress]
  for_each = var.ses_domains
  name = "${each.key}-bounce-fallback"
  rule_set_name = aws_ses_receipt_rule_set.receiving_rulesets.id
  recipients = [each.key]
  enabled       = true
  after = aws_ses_receipt_rule.email_ingress[each.key].id

  bounce_action {
    message = "Mailbox does not exist"
    sender = "postmaster@${each.key}"
    smtp_reply_code = "550"
    status_code = "5.1.1"
    position = 1
  }

  stop_action {
    scope = "RuleSet"
    position = 2
  }
}
