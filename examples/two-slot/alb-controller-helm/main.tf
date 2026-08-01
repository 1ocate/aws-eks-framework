provider "aws" {
  region = var.aws_region
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes = {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name, "--region", var.aws_region]
    }
  }
}

module "alb_controller" {
  source = "../../../modules/eks-alb-controller-helm"

  cluster_name                   = var.cluster_name
  aws_region                     = var.aws_region
  vpc_id                         = var.vpc_id
  iam_role_arn                   = var.iam_role_arn
  chart_version                  = var.chart_version
  enable_service_mutator_webhook = var.enable_service_mutator_webhook
}
