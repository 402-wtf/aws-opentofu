resource "cloudflare_record" "mx_records" {
  for_each = var.ses_domains
  zone_id  = data.cloudflare_zone.dns_zone[each.key].id
  name     = each.key
  value    = "inbound-smtp.${data.aws_region.current.name}.amazonaws.com"
  type     = "MX"
  ttl      = 300
  priority = 100
  comment  = "AWS SES MX - ${each.key} - Managed by OpenTofu"
}

resource "cloudflare_record" "spf_records" {
  for_each = var.ses_domains
  zone_id  = data.cloudflare_zone.dns_zone[each.key].id
  name     = each.key
  value    = "v=spf1 include:_spf.mx.cloudflare.net include:amazonses.com ~all"
  type     = "TXT"
  ttl      = 300
  comment  = "AWS SES SPF - ${each.key} - Managed by OpenTofu"
}


