variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "vpc-name" {
  default = "eks-vpc"
}

variable "aws-region" {
  description = "region for aws"
  default     = "us-west-2"
}

data "aws_availability_zones" "available_zones" {
  state = "available"
}

variable "az-amount" {
  default = "2"
}

variable "cluster-name" {
  default = "moduled-eks"
}

variable "cluster-version" {
  default = "1.24"
}

variable "managed-node-group-disk-size" {
  default = 30
}

variable "node-group-des" {
  default = 2
}

variable "node-group-min" {
  default = 2
}

variable "node-group-max" {
  default = 4
}

variable "node-group-role-tag" {
  default = "general"
}

variable "initial-instance-types" {
  type    = list(any)
  default = ["t2.medium"]
}

variable "spot-node-group-role-tag" {
  default = "spot"
}
variable "subnet-bits" {
  default = 4
}

#################################################################################
# KARPENTER CONFIGURATION
#################################################################################
variable "karpenter-repo" {
  default = "oci://public.ecr.aws/karpenter"
}

variable "karpenter-chart" {
  default = "karpenter"
}

variable "karpenter-chart-version" {
  default = "v0.20.0"
}

variable "karpenter-capacity-type" {
  default = "[\"spot\", \"on-demand\"]"
}

variable "karpenter-cpu-limit" {
  default = 100
}

variable "karpenter-ttl-empty" {
  default = 30
}

variable "karpenter-instance-category" {
  default = "[\"t\"]"
}

variable "karpenter-ttl-expired" {
  # in seconds, this is 1 day. 60 * 60 * 24 = 86400
  default = 86400
}

variable "karpenter-instance-generation" {
  default = "[\"2\"]"
}

variable "karpenter-subnet-tag" {
  default = "karpenter.sh/discovery"
}
