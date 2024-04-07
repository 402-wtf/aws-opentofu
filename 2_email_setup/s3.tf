resource "aws_s3_bucket" "domain_mailboxes" {
  for_each = var.ses_domains
  bucket_prefix = "${var.prefix}-mailstore-"
  tags = {
    ses_domain = each.key
  }
}

data "aws_iam_policy_document" "allow_ses_to_rw_to_s3" {
  for_each = var.ses_domains
  statement {
    sid = "AllowSESPuts"
    effect = "Allow"
    principals {
      identifiers = ["ses.amazonaws.com"]
      type = "Service"
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.domain_mailboxes[each.key].id}/*"]
    condition {
      test = "StringEquals"
      variable = "AWS:SourceAccount"
      values = [data.aws_caller_identity.current.account_id]
    }
    dynamic "condition" {
      for_each = var.ses_domains
      content {
        test = "StringEquals"
        variable = "AWS:SourceArn"
        values = ["arn:aws:ses:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:receipt-rule-set/default_ruleset:receipt-rule/${each.key}-ingress"]
      }
    }
  }
}

resource "aws_s3_bucket_policy" "allow_ses_to_rw_to_s3" {
  for_each = var.ses_domains
  bucket = aws_s3_bucket.domain_mailboxes[each.key].id
  policy = data.aws_iam_policy_document.allow_ses_to_rw_to_s3[each.key].json
}
