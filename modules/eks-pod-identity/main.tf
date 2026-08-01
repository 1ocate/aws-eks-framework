locals {
  common_tags = merge(var.tags, { "managed-by" = "terraform" })
}

resource "aws_eks_addon" "agent" {
  cluster_name                = var.cluster_name
  addon_name                  = "eks-pod-identity-agent"
  addon_version               = var.agent_addon_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = local.common_tags
}

resource "aws_eks_pod_identity_association" "this" {
  for_each = var.associations

  cluster_name    = var.cluster_name
  namespace       = each.value.namespace
  service_account = each.value.service_account_name
  role_arn        = each.value.role_arn

  tags = local.common_tags

  depends_on = [aws_eks_addon.agent]
}
