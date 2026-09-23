output "release_name" {
  description = "Installed Helm release name."
  value       = helm_release.this.name
}

output "namespace" {
  description = "Namespace containing the Argo CD control plane."
  value       = helm_release.this.namespace
}
