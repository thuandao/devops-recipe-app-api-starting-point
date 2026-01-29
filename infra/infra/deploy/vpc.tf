module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "${local.prefix}-vpc"
  cidr = "10.1.0.0/16"

  azs = [
    "${data.aws_region.current.name}a",
    "${data.aws_region.current.name}b"
  ]

  public_subnets = [
    "10.1.1.0/24",
    "10.1.2.0/24"
  ]

  private_subnets = [
    "10.1.10.0/24",
    "10.1.11.0/24"
  ]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = false   # ECS Fargate + endpoints → không cần NAT
  single_nat_gateway = false

  tags = {
    Project = local.prefix
  }
}
