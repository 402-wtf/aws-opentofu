resource "aws_s3_bucket" "opentofu_state" {
  bucket = "${var.prefix}_opentofu_state"
}
