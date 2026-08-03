output "role_arn" {
  description = "IRSA role ARN to annotate on the Karpenter controller service account."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Karpenter controller IAM role name."
  value       = aws_iam_role.this.name
}
