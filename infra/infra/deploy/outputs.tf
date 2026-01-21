output "api_endpoint" {
  value = aws_route53_record.app.fqdn
}

output "bastion_host" {
  value = aws_instance.bastion.public_dns
}
