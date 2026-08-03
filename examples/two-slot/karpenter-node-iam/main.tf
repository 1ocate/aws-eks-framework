provider "aws" {
  region = var.aws_region
}

module "karpenter_node_iam" {
  source = "../../../modules/eks-karpenter-node-iam"

  cluster_name   = var.cluster_name
  node_role_name = var.node_role_name
  tags           = { environment = "example" }
}
