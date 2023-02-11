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
  #  node_security_group_additional_rules = {
#    ingress_nodes_karpenter_port = {
#      description                   = "Cluster API to Node group for Karpenter webhook"
#      protocol                      = "tcp"
#      from_port                     = 8443
#      to_port                       = 8443
#      type                          = "ingress"
#      source_cluster_security_group = true
#    }
#  }

  aws_auth_roles = [
    {
      rolearn = module.karpenter_iam_role.iam_role_arn
      username = module.karpenter_iam_role.iam_role_name
      groups = ["system:masters"]
    }
  ]

  eks_managed_node_group_defaults = {
    disk_size = var.managed-node-group-disk-size
  }

  eks_managed_node_groups = {
    general = {
      create_security_group = false

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