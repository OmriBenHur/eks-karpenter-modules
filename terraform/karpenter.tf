module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "18.31.0"

  cluster_name = var.cluster-name

  irsa_oidc_provider_arn          = module.eks.oidc_provider_arn
  irsa_namespace_service_accounts = ["karpenter:karpenter"]

  # Since Karpenter is running on an EKS Managed Node group,
  # we can re-use the role that was created for the node group
  create_iam_role = false
  iam_role_arn    = module.eks.eks_managed_node_groups["general"].iam_role_arn
}

#module "karpenter_iam_policy" {
#  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
#  version = "5.3.1"
#
#  name          = "allow-karpenter-access"
#  create_policy = true
#
#  policy = file("./kapenter-policy.json")
#}
#
#module "karpenter_iam_role" {
#  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#  version = "5.3.1"
#
#  role_name         = "${var.cluster-name}-karpenter"
#  create_role       = true
#  provider_url = module.eks.cluster_oidc_issuer_url
#
#  role_policy_arns = [module.karpenter_iam_policy.arn]
#
#  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
#}
#
#resource "aws_iam_instance_profile" "karpenter-instance-profile" {
#  name = "karpenter-instance-profile"
#  role = module.karpenter_iam_role.iam_role_name
#}