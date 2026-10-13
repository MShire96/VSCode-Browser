variable "alb_name" {
  type = string
}

variable "myip" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_name" {
  type = string
}

variable "lb_target_group_name" {
  type    = string
  default = "vscoder-ecs-target-group"
}

variable "acm_cert_validation_arn" {
  type = string  
}



