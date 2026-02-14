{
  "version": "1",
  "Resources": [
    {
      "TargetService": {
        "Type": "AWS::ECS::Service",
        "Properties": {
          "TaskDefinition": "__TASK_DEFINITION__",
          "LoadBalancerInfo": {
            "ContainerName": "proxy",
            "ContainerPort": 8000
          }
        }
      }
    }
  ]
}
