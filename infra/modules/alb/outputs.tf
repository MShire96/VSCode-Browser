output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.vscoder.arn
}

output "alb_dns_name" {
  value = aws_lb.vscoder.dns_name  
}

output "alb_zone_id" {
  value = aws_lb.vscoder.zone_id
}