variable "ecr_repo_name" {}
variable "vscode_s3_bucket_name" {}
variable "allowed_subjects" {}
variable "actions_role_name" {
  
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}