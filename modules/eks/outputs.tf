output "cluster_name" {
  description = "EKS cluster name."
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "EKS API endpoint."
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64-encoded EKS cluster CA data."
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}

output "oidc_provider_arn" {
  description = "OIDC provider ARN for workload identity (IRSA) bindings managed outside this module."
  value       = aws_iam_openid_connect_provider.this.arn
}

output "oidc_provider_url" {
  description = "OIDC issuer URL for workload identity (IRSA) bindings."
  value       = aws_iam_openid_connect_provider.this.url
}
