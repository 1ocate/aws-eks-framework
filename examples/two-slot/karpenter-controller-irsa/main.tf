provider "aws" {
  region = var.aws_region
}

module "karpenter_controller_irsa" {
  source = "../../../modules/eks-karpenter-controller-irsa"

  cluster_name           = var.cluster_name
  oidc_provider_arn      = var.oidc_provider_arn
  oidc_provider_url      = var.oidc_provider_url
  node_role_arn          = var.node_role_arn
  interruption_queue_arn = var.interruption_queue_arn
  role_name              = var.role_name
  tags                   = { environment = "example" }
}
