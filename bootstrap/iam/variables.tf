variable "aws_caller_arn" {}
variable "ecr_repository_name" {}
variable "aws_region" {
  type = string
}
variable "actions_role_name" {
  type = string
}
variable "allowed_subjects" {
  type = list(string)
}