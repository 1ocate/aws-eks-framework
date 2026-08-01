locals {
  role_name   = coalesce(var.role_name, "${var.cluster_name}-ebs-csi")
  issuer_host = trimprefix(var.oidc_provider_url, "https://")
  common_tags = merge(var.tags, { "managed-by" = "terraform" })
}

resource "aws_iam_role" "this" {
  name = local.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRoleWithWebIdentity"
      Principal = { Federated = var.oidc_provider_arn }
      Condition = {
        StringEquals = {
          "${local.issuer_host}:aud" = "sts.amazonaws.com"
          "${local.issuer_host}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
        }
      }
    }]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arn
}

resource "aws_eks_addon" "this" {
  cluster_name                = var.cluster_name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.addon_version
  service_account_role_arn    = aws_iam_role.this.arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"

  tags = local.common_tags

  depends_on = [aws_iam_role_policy_attachment.this]
}
