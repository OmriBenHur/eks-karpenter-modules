output "eks-update-kube-config" {
  value = "aws eks update-kubeconfig --region ${var.aws-region} --name ${var.cluster-name}"
}