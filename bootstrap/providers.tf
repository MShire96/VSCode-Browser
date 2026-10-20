terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project = "vscode"
      Owner   = "mohamed"
      Use = "Bootstrap"
    }
  }
}

data "aws_caller_identity" "current" {}