output "eks-update-kube-config" {
  value = "aws eks update-kubeconfig --region ${var.aws-region} --name ${var.cluster-name}"
}

output "monitor-karpenter-controller" {
  value = "kubectl logs -f -n karpenter -l app.kubernetes.io/name=karpenter -c controller"
}