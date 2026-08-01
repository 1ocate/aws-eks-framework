variable "cluster_name" {
  description = "Name of the target EKS cluster."
  type        = string
}

variable "agent_addon_version" {
  description = "Pinned eks-pod-identity-agent add-on version compatible with the target EKS version."
  type        = string

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+-eksbuild\\.[0-9]+$", var.agent_addon_version))
    error_message = "agent_addon_version must use the form vX.Y.Z-eksbuild.N."
  }
}

variable "associations" {
  description = "Pod Identity associations keyed by a stable logical name. IAM roles must trust pods.eks.amazonaws.com."
  type = map(object({
    namespace            = string
    service_account_name = string
    role_arn             = string
  }))
  default = {}

  validation {
    condition = alltrue([
      for association in values(var.associations) :
      length(trimspace(association.namespace)) > 0 &&
      length(trimspace(association.service_account_name)) > 0 &&
      can(regex("^arn:aws:iam::[0-9]{12}:role/.+", association.role_arn))
    ])
    error_message = "Every association needs a namespace, service account name, and IAM role ARN."
  }
}

variable "tags" {
  description = "Additional tags applied to AWS resources."
  type        = map(string)
  default     = {}
}
