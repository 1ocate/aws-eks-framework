variable "cluster_name" {
  description = "EKS cluster name that Karpenter manages."
  type        = string
}

variable "interruption_queue_name" {
  description = "Name of the SQS interruption queue created for this cluster."
  type        = string

  validation {
    condition     = length(trimspace(var.interruption_queue_name)) > 0
    error_message = "interruption_queue_name must not be empty."
  }
}

variable "iam_role_arn" {
  description = "IRSA role ARN for the Karpenter controller service account."
  type        = string

  validation {
    condition     = can(regex("^arn:[^:]+:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "iam_role_arn must be an IAM role ARN."
  }
}

variable "chart_version" {
  description = "Exact Karpenter Helm chart version."
  type        = string
  default     = "1.14.0"
}

variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "karpenter"
}

variable "namespace" {
  description = "Namespace created for the Karpenter controller."
  type        = string
  default     = "karpenter"
}

variable "service_account_name" {
  description = "Service account name Helm creates and annotates for IRSA."
  type        = string
  default     = "karpenter"
}

variable "enable_zonal_shift" {
  description = "Whether the EKS cluster has Amazon ARC zonal shift enabled for Karpenter."
  type        = bool
  default     = false
}

variable "isolated_vpc" {
  description = "Whether Karpenter runs in a private VPC with the required AWS VPC endpoints."
  type        = bool
  default     = false
}

variable "controller_cpu_request" {
  description = "CPU request for the Karpenter controller."
  type        = string
  default     = "1"
}

variable "controller_memory_request" {
  description = "Memory request for the Karpenter controller."
  type        = string
  default     = "1Gi"
}

variable "controller_cpu_limit" {
  description = "CPU limit for the Karpenter controller."
  type        = string
  default     = "1"
}

variable "controller_memory_limit" {
  description = "Memory limit for the Karpenter controller."
  type        = string
  default     = "1Gi"
}

variable "timeout_seconds" {
  description = "Maximum wait time for Helm operations in seconds."
  type        = number
  default     = 600

  validation {
    condition     = var.timeout_seconds > 0
    error_message = "timeout_seconds must be greater than 0."
  }
}
