variable "cluster_name" {
  description = "EKS cluster name managed by the controller."
  type        = string
}

variable "aws_region" {
  description = "AWS region of the EKS cluster and VPC."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID used by the controller for load balancer discovery."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must be an AWS VPC ID."
  }
}

variable "iam_role_arn" {
  description = "IRSA role ARN for the controller service account."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "iam_role_arn must be an IAM role ARN."
  }
}

variable "chart_version" {
  description = "Exact AWS Load Balancer Controller Helm chart version."
  type        = string
  default     = "1.14.0"
}

variable "release_name" {
  description = "Helm release name."
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "namespace" {
  description = "Existing namespace containing the controller service account."
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account name that Helm creates and annotates for IRSA."
  type        = string
  default     = "aws-load-balancer-controller"
}

variable "replica_count" {
  description = "Number of controller replicas."
  type        = number
  default     = 2

  validation {
    condition     = var.replica_count >= 1
    error_message = "replica_count must be at least 1."
  }
}

variable "enable_service_mutator_webhook" {
  description = "Whether new LoadBalancer Services default to the controller-managed NLB class."
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
