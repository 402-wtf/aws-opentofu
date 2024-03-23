resource "aws_ses_domain_identity" "domains" {
  for_each = var.ses_domains
  domain   = each.key
}
