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

output "ecs_task_family" {
  value = aws_ecs_task_definition.api.family
}

output "codedeploy_app_name" {
  description = "CodeDeploy Application name"
  value       = aws_codedeploy_app.ecs.name
}

output "codedeploy_deployment_group_name" {
  description = "CodeDeploy Deployment Group name"
  value       = aws_codedeploy_deployment_group.ecs.deployment_group_name
}
