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
    bucket       = "vscode-terraform-bucket"
    key          = "tf-state-deploy"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

data "aws_ecr_repository" "vscoder" {
  name = "vscode"
}

data "aws_ecr_image" "vscoder" {
  repository_name = data.aws_ecr_repository.vscoder.name
  image_tag       = "latest"
}

data "aws_route53_zone" "moshire" {
  name         = var.hosted_zone_name
}