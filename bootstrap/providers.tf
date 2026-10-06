terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

provider "aws" {
  # Configuration options

  default_tags {
    tags = {
      Project     = "vscode"
      Owner       = "mohamed"
    }
  }
}

data "aws_caller_identity" "current" {}