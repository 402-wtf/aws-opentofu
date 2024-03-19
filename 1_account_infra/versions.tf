terraform {
  required_providers {
    aws = {
      version = "~> 5.41.0"
      source  = "opentofu/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "Managed-By" = "OpenTofu"
      "Repo" = "aws-opentofu"
    }
  }
}
