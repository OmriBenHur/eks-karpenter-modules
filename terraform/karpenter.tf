#module "karpenter" {
#  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
#  version = "18.31.0"
#
#  cluster_name = module.eks.cluster_name
#
#  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
#  irsa_namespace_service_accounts = ["karpenter:karpenter"]
#
#  # Since Karpenter is running on an EKS Managed Node group,
#  # we can re-use the role that was created for the node group
#  create_iam_role = false
#  iam_role_arn    = module.eks.eks_managed_node_groups["initial"].iam_role_arn
#}
#
#resource "helm_release" "karpenter" {
#  namespace        = "karpenter"
#  create_namespace = true
#
#  name                = "karpenter"
#  repository          = var.karpenter-repo
#  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
#  repository_password = data.aws_ecrpublic_authorization_token.token.password
#  chart               = var.karpenter-chart
#  version             = var.karpenter-chart-version
#
#  set {
#    name  = "settings.aws.clusterName"
#    value = module.eks.cluster_name
#  }
#
#  set {
#    name  = "settings.aws.clusterEndpoint"
#    value = module.eks.cluster_endpoint
#  }
#
#  set {
#    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#    value = module.karpenter.irsa_arn
#  }
#
#  set {
#    name  = "settings.aws.defaultInstanceProfile"
#    value = module.karpenter.instance_profile_name
#  }
#
#  set {
#    name  = "settings.aws.interruptionQueueName"
#    value = module.karpenter.queue_name
#  }
#}