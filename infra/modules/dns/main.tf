data "aws_route53_zone" "moshire" {
  name         = var.hosted_zone_name
}

resource "aws_route53_record" "vscode_arecord" {
  zone_id = data.aws_route53_zone.moshire.zone_id
  name    = var.a_record_name
  type    = "A"

    alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = false
  }
}