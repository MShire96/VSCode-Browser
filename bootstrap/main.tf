module "iam" {
  source         = "./iam"
  aws_caller_arn = data.aws_caller_identity.current.arn
  actions_role_name = var.actions_role_name
  aws_region = var.aws_region
  allowed_subjects = var.allowed_subjects
  ecr_repository_name = var.ecr_repo_name
}

module "s3" {
  source             = "./s3"
  aws_s3_bucket_name = var.vscode_s3_bucket_name
}

module "ecr" {
  source        = "./ecr"
  ecr_repo_name = var.ecr_repo_name
}



