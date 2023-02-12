resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: default
    spec:
     requirements:
      - key: node.kubernetes.io/instance-type
        operator: In
        values: ${var.karpenter-capacity-type}
#      - key: karpenter.k8s.aws/instance-category
#        operator: In
#        values: ${var.karpenter-instance-category}
#      - key: karpenter.k8s.aws/instance-generation
#        operator: Gt
#        values: ${var.karpenter-instance-generation}
      limits:
        resources:
          cpu: ${var.karpenter-cpu-limit}
      providerRef:
        name: default
      ttlSecondsAfterEmpty: ${var.karpenter-ttl-empty}
      ttlSecondsUntilExpired: ${var.karpenter-ttl-expired}
  YAML

  depends_on = [helm_release.karpenter]
}

resource "kubectl_manifest" "karpenter_node_template" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: default
    spec:
      subnetSelector:
        ${var.karpenter-subnet-tag}: "true"
      securityGroupSelector:
        karpenter.sh/discovery: ${module.eks.cluster_name}
      tags:
        karpenter.sh/discovery: ${module.eks.cluster_name}
  YAML

  depends_on = [kubectl_manifest.karpenter_provisioner]
}

resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mongodb-deployment
      labels:
        app: mongodb
    spec:
      replicas: 3
      selector:
        matchLabels:
          app: mongodb
      template:
        metadata:
          labels:
            app: mongodb
        spec:
          containers:
          - name: mongodb
            image: mongo
            ports:
            - containerPort: 27017
            resources:
              requests:
                cpu: 2
  YAML

  depends_on = [kubectl_manifest.karpenter_node_template]
}
