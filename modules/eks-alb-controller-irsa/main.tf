locals {
  role_name   = coalesce(var.role_name, "${var.cluster_name}-alb-controller")
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
      Condition = { StringEquals = {
        "${local.issuer_host}:aud" = "sts.amazonaws.com"
        "${local.issuer_host}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
      } }
    }]
  })
  tags = local.common_tags
}
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = var.iam_policy_arn
}
