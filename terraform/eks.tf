module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name = var.cluster-name
  cluster_version = "1.23"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true
  manage_aws_auth_configmap = true
  aws_auth_roles = [
    {
      rolearn = module.eks_admins_iam_role.iam_role_arn
      username = module.eks_admins_iam_role.iam_role_name
      groups = ["system:masters"]
    }
  ]

  eks_managed_node_group_defaults = {
    disk_size = var.managed-node-group-disk-size
  }

  eks_managed_node_groups = {
    general = {
      desired_size = var.node-group-des
      min_size = var.node-group-min
      max_size = var.node-group-max

      labels = {
        role = var.node-group-role-tag
      }

      instance_types = var.general-instance-types
      capacity_type = "ON_DEMAND"
    }

    spot = {
      desired_size = var.spot-node-group-des
      min_size = var.spot-node-group-min
      max_size = var.spot-node-group-max

      labels = {
        role = var.spot-node-group-role-tag
      }

      instance_types = var.spot-instance-types
      capacity_type = "SPOT"
    }
  }
}