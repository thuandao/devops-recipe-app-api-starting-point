output "api_endpoint" {
  value = aws_route53_record.app.fqdn
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value = aws_ecs_service.api.name
}
