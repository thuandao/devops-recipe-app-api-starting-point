data "aws_route53_zone" "zone" {
  name = "${var.dns_zone_name}."
}

module "app_dns" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_id = data.aws_route53_zone.zone.zone_id

  records = [
    {
      name = lookup(var.subdomain, terraform.workspace)
      type = "CNAME"
      ttl  = 300
      records = [aws_lb.api.dns_name]
    }
  ]
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = trimsuffix("${lookup(var.subdomain, terraform.workspace)}.${data.aws_route53_zone.zone.name}", ".")

  zone_id = data.aws_route53_zone.zone.zone_id

  validation_method = "DNS"

  wait_for_validation = true

  tags = {
    Name = "${local.prefix}-cert"
  }
}
