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
      source = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }
}

# provider conf. enter the region you're operating in
provider "aws" {
  region = "us-west-2"
}

data "aws_eks_cluster_auth" "cluster-auth" {
  name       = module.eks.cluster_id
}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token = data.aws_eks_cluster_auth.cluster-auth.token
}
