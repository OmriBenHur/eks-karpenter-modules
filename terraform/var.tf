variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "vpc-name" {
  default = "eks-vpc"
}

variable "aws-region" {
  description = "region for aws"
  default = "us-west-2"
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

variable "general-instance-types" {
  type = list(any)
  default = ["t2.medium"]
}

variable "spot-node-group-des" {
  default = 1
}

variable "spot-node-group-min" {
  default = 0
}

variable "spot-node-group-max" {
  default = 4
}

variable "spot-node-group-role-tag" {
  default = "spot"
}
variable "subnet-bits" {
  default = 4
}

variable "spot-instance-types" {
  type = list(any)
  default = ["t2.small"]
}
 locals {
   azs = slice(data.aws_availability_zones.available_zones.names,0,var.az-amount)
 }

variable "karpenter-repo" {
  default = "https://charts.karpenter.sh/"
}

variable "karpenter-chart" {
  default = "karpenter"
}

variable "karpenter-chart-version" {
  default = "v0.13.1"
}
