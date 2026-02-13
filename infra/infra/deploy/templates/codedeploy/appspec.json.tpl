{
  "version": 1,
  "Resources": [
    {
      "TargetService": {
        "Type": "AWS::ECS::Service",
        "Properties": {
          "TaskDefinition": "__TASK_DEFINITION__",
          "LoadBalancerInfo": {
            "ContainerName": "api",
            "ContainerPort": 8000
          }
        }
      }
    }
  ]
}
