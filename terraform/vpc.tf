module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.3"

  name = var.vpc-name
  cidr = var.vpc-cidr

  azs = [for o in local.azs : tostring(o)]
  public_subnets = [for k, v in module.vpc.azs : cidrsubnet(var.vpc-cidr, 6, k)]
  private_subnets  = [for k, v in module.vpc.azs  : cidrsubnet(var.vpc-cidr, 6, k + 2)]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support = true

}