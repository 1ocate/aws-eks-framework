module "pod_identity" {
  source = "../../../modules/eks-pod-identity"

  cluster_name        = var.cluster_name
  agent_addon_version = var.agent_addon_version
  associations        = var.associations

  tags = { environment = "example" }
}
