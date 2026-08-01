module "ebs_csi" {
  source = "../../../modules/eks-ebs-csi"

  cluster_name      = var.cluster_name
  oidc_provider_arn = var.oidc_provider_arn
  oidc_provider_url = var.oidc_provider_url
  addon_version     = var.addon_version

  tags = { environment = "example" }
}
