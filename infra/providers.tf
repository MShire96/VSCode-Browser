terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = var.terraform_deployment_role_arn
  }
}

terraform {
  backend "s3" {
    bucket = "vscode-terraform-bucket"
    key    = "tf-state-deploy"
    region = "us-east-1"
    encrypt = true
    use_lockfile = true
  }
}