variable "prefix" {
  type        = string
  default     = "402-wtf"
  description = "The prefix to use for created resources"
}

variable "ses_domains" {
  type        = list(string)
  default     = []
  description = "A list of domain names to use as SES identities"
}
