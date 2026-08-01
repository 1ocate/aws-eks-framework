variable "chart_version" {
  description = "Exact Cilium Helm chart version."
  type        = string
  default     = "1.19.6"
}

variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "cilium"
}

variable "namespace" {
  description = "Existing namespace for the Cilium release."
  type        = string
  default     = "kube-system"
}

variable "operator_replicas" {
  description = "Number of Cilium operator replicas."
  type        = number
  default     = 2

  validation {
    condition     = var.operator_replicas >= 1
    error_message = "operator_replicas must be at least 1."
  }
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
