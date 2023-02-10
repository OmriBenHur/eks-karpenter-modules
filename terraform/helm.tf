
resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = var.karpenter-repo
  chart               = var.karpenter-chart
  version             = var.karpenter-chart-version

  set {
    name  = "settings.aws.clusterName"
    value = module.eks.cluster_id
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.irsa_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }
#
#  set {
#    name  = "settings.aws.interruptionQueueName"
#    value = module.karpenter.queue_name
#  }
}
