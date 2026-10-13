terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

provider "aws" {

  default_tags {
    tags = {
      Project = "vscode"
      Owner   = "mohamed"
      Use = "Bootstrap"
    }
  }
}

data "aws_caller_identity" "current" {}