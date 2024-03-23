resource "aws_ses_domain_identity" "domains" {
  for_each = var.ses_domains
  domain   = each.key
}

resource "aws_ses_domain_dkim" "domains" {
  for_each = var.ses_domains
  domain = aws_ses_domain_identity.domains[each.key].domain
}
