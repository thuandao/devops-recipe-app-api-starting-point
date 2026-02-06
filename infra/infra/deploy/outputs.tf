output "api_endpoint" {
  value = aws_route53_record.app.fqdn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.api.name
}
