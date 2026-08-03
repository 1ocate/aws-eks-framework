output "node_role_arn" {
  description = "ARN to set as the EC2NodeClass role."
  value       = aws_iam_role.this.arn
}

output "node_role_name" {
  description = "Name to set as the EC2NodeClass role."
  value       = aws_iam_role.this.name
}
