module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.14.3"

  name = var.vpc-name
  cidr = var.vpc-cidr

  azs = [for o in local.azs : tostring(o)]
  public_subnets = [for k, v in module.vpc.azs : cidrsubnet(var.vpc-cidr, var.subnet-bits, k)]
  private_subnets  = [for k, v in module.vpc.azs  : cidrsubnet(var.vpc-cidr, var.subnet-bits, k + var.az-amount)]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  enable_dns_hostnames = true
  enable_dns_support = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = "true"
  }
}
