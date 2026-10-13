module "vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr_block
  public_cidr    = var.public_cidr
  private_cidr   = var.private_cidr
}

module "alb" {
  source            = "./modules/alb"
  alb_name          = var.alb_name
  myip              = var.myip
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_name       = var.alb_sg_name
  vpc_id            = module.vpc.vpc_id
  acm_cert_validation_arn = module.acm.acm_certificate_validation_arn
}

module "ecs" {
  source                         = "./modules/ecs"
  ecs_cluster_name               = var.ecs_cluster_name
  ecs_task_name                  = var.ecs_task_name
  vscoder_ecr_imageuri           = data.aws_ecr_image.vscoder.image_uri
  ecr_task_execution_role_policy = var.ecr_task_execution_role_policy
  vpc_id                         = module.vpc.vpc_id
  alb_sg_id                      = module.alb.alb_sg_id
  alb_target_group_arn           = module.alb.alb_target_group_arn
  private_subnet_ids             = module.vpc.private_subnet_ids
}

module "dns" {
  source = "./modules/dns"
  vscode_elb_ip = module.alb.alb_dns_name
  hosted_zone_name = var.hosted_zone_name
  a_record_name = var.a_record_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
}

module "acm" {
  source = "./modules/acm"
  a_record_name = var.a_record_name
  r53_hosted_zone_id = data.aws_route53_zone.moshire.zone_id
}