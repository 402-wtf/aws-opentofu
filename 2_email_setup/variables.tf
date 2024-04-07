variable "prefix" {
  type        = string
  default     = "402-wtf"
  description = "The prefix to use for created resources"
}

variable "ses_domains" {
  type        = set(string)
  default     = []
  description = "A list of domain names to use as SES identities"
}
