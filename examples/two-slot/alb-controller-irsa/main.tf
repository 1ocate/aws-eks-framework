module "alb_controller_irsa" {
  source            = "../../../modules/eks-alb-controller-irsa"
  cluster_name      = var.cluster_name
  oidc_provider_arn = var.oidc_provider_arn
  oidc_provider_url = var.oidc_provider_url
  iam_policy_arn    = var.iam_policy_arn
  tags              = { environment = "example" }
}
