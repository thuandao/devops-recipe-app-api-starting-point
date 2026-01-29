#########################################################################
## Endpoints to allow ECS to access ECR, CloudWatch and Systems Manager #
#########################################################################
resource "aws_security_group" "endpoint_access" {
  description = "Access to endpoints"
  name        = "${local.prefix}-endpoint-access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    cidr_blocks = [module.vpc.vpc_cidr_block]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  
  tags = {
    Name = "${local.prefix}-endpoint-sg"
  }
}

module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  security_group_ids = [
    aws_security_group.endpoint_access.id
  ]

  subnet_ids = module.vpc.private_subnets

  endpoints = {
    ecr_api = {
      service = "ecr.api"
      private_dns_enabled = true
      tags = {
        Name = "${local.prefix}-ecr-api-endpoint"
      }
    }

    ecr_dkr = {
      service = "ecr.dkr"
      private_dns_enabled = true
      tags = {
        Name = "${local.prefix}-ecr-dkr-endpoint"
      }
    }

    logs = {
      service = "logs"
      private_dns_enabled = true
      tags = {
        Name = "${local.prefix}-logs-endpoint"
      }
    }

    ssmmessages = {
      service = "ssmmessages"
      private_dns_enabled = true
      tags = {
        Name = "${local.prefix}-ssmmessages-endpoint"
      }
    }

    s3 = {
      service = "s3"
      service_type = "Gateway"
      route_table_ids = [module.vpc.main.default_route_table_id]
      tags = {
        Name = "${local.prefix}-s3-endpoint"
      }
    }
  }

  tags = {
    Project = local.prefix
  }
}
