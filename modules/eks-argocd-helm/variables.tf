variable "chart_version" {
  description = "Exact Argo CD Helm chart version."
  type        = string
  default     = "10.2.1"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.chart_version))
    error_message = "chart_version must be an exact semantic version."
  }
}

variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "argo-cd"
}

variable "namespace" {
  description = "Namespace created for the Argo CD control plane."
  type        = string
  default     = "argocd"
}

variable "high_availability" {
  description = "Whether to deploy the Argo CD chart's non-autoscaling HA topology; it requires at least three worker nodes."
  type        = bool
  default     = false
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
