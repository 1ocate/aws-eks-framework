output "agent_addon_version" {
  description = "Pinned version of the installed EKS Pod Identity Agent add-on."
  value       = aws_eks_addon.agent.addon_version
}

output "association_ids" {
  description = "Pod Identity association IDs keyed by logical association name."
  value = {
    for name, association in aws_eks_pod_identity_association.this : name => association.id
  }
}
