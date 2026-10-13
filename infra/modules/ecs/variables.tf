variable "ecs_cluster_name" {
  type = string
}

variable "ecs_task_name" {
  type = string
}

variable "vscoder_ecr_imageuri" {
  type = string
}

variable "vscode_family" {
  type    = string
  default = "vscode_family"
}

variable "ecr_execution_role_name" {
  type    = string
  default = "vscoder-execution-role"
}

variable "ecr_task_execution_role_policy" {
  type = string
}

variable "ecs_sg_name" {
  type    = string
  default = "ecs_security_group"
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "alb_target_group_arn" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}