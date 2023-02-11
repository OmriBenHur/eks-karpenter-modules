module "karpenter_iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "5.3.1"

  name          = "allow-karpenter-access"
  create_policy = true

  policy        = file("./kapenter-policy.json")
}

module "karpenter_iam_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.3.1"

  role_name         = "${var.cluster-name}-karpenter"
  create_role       = true
  provider_url      = module.eks.cluster_oidc_issuer_url

  role_policy_arns = [module.karpenter_iam_policy.arn]

  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
}

resource "aws_iam_instance_profile" "karpenter-instance-profile" {
  name = "karpenter-instance-profile"
  role = module.karpenter_iam_role.iam_role_name
}