# Create route53
resource "aws_route53_zone" "ugwulo" {
  name = var.domain_name
}

# Create an A record sub-domain
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.ugwulo.zone_id
  name    = var.sub_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = true
  }
}