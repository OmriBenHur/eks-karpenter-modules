# using terraform cloud to run these configuration files.
# aws access key and secret key are saved as env variables in the tf cloud workspace. so no declaration in code is needed
terraform {
  cloud {
    organization = "omribenhur"

    workspaces {
      name = "eks-modules"
    }
  }

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
#
#data "aws_eks_cluster_auth" "cluster-auth" {
#  name = var.cluster-name
#  depends_on = [module.eks]
#}
#
#data "aws_eks_cluster" "cluster" {
#  name = var.cluster-name
#  depends_on = [module.eks]
#
#}

data "aws_partition" "current" {}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

# provider conf. enter the region you're operating in
provider "aws" {
  region = var.aws-region
}

provider "aws" {
  # for ecr token.
  region = "us-east-1"
  alias  = "virginia"
}
#
#provider "helm" {
#  kubernetes {
#    host                   = data.aws_eks_cluster.cluster.endpoint
#    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#    token                  = data.aws_eks_cluster_auth.cluster-auth.token
#  }
#}
#
#provider "kubectl" {
#  host                   = data.aws_eks_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#  token                  = data.aws_eks_cluster_auth.cluster-auth.token
#  load_config_file       = false
#}

locals {
  azs       = slice(data.aws_availability_zones.available_zones.names, 0, var.az-amount)
  partition = data.aws_partition.current.partition

}

