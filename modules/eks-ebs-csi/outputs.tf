output "addon_name" {
  description = "Name of the installed EKS add-on."
  value       = aws_eks_addon.this.addon_name
}

output "addon_version" {
  description = "Pinned version of the installed EKS add-on."
  value       = aws_eks_addon.this.addon_version
}

output "iam_role_arn" {
  description = "IAM role ARN bound to the EBS CSI controller service account."
  value       = aws_iam_role.this.arn
}
