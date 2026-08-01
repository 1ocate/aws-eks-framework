variable "cluster_name" {
  description = "Name of the target EKS cluster."
  type        = string
}

variable "oidc_provider_arn" {
  description = "IAM OIDC provider ARN exported by the EKS cluster module."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:oidc-provider/.+", var.oidc_provider_arn))
    error_message = "oidc_provider_arn must be an IAM OIDC provider ARN."
  }
}

variable "oidc_provider_url" {
  description = "OIDC issuer URL exported by the EKS cluster module."
  type        = string

  validation {
    condition     = can(regex("^https://", var.oidc_provider_url))
    error_message = "oidc_provider_url must be an HTTPS URL."
  }
}

variable "addon_version" {
  description = "Pinned aws-ebs-csi-driver add-on version compatible with the target EKS Kubernetes version."
  type        = string

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+-eksbuild\\.[0-9]+$", var.addon_version))
    error_message = "addon_version must use the form vX.Y.Z-eksbuild.N."
  }
}

variable "role_name" {
  description = "Optional IAM role name. When null, it is derived from cluster_name."
  type        = string
  default     = null
}

variable "policy_arn" {
  description = "AWS managed or organization-managed policy ARN for EBS CSI permissions."
  type        = string
  default     = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicyV2"

  validation {
    condition     = can(regex("^arn:aws:iam::(aws|[0-9]{12}):policy/.+", var.policy_arn))
    error_message = "policy_arn must be an IAM managed policy ARN."
  }
}

variable "namespace" {
  description = "Namespace of the EBS CSI controller service account."
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Name of the EBS CSI controller service account."
  type        = string
  default     = "ebs-csi-controller-sa"
}

variable "tags" {
  description = "Additional tags applied to AWS resources."
  type        = map(string)
  default     = {}
}
