terraform {
  required_providers {
    aws = {
      version = "~> 5.41.0"
      source  = "opentofu/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.26.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Managed-By" = "OpenTofu"
      "Repo"       = "aws-opentofu"
    }
  }
}
