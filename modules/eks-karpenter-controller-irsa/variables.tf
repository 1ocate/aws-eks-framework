variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "node_role_arn" {
  description = "Karpenter node role ARN that the controller may pass to EC2."
  type        = string
  validation {
    condition     = can(regex("^arn:[^:]+:iam::[0-9]{12}:role/.+", var.node_role_arn))
    error_message = "node_role_arn must be an IAM role ARN."
  }
}

variable "interruption_queue_arn" {
  description = "SQS queue ARN that receives Karpenter interruption events."
  type        = string
  validation {
    condition     = can(regex("^arn:[^:]+:sqs:[^:]+:[0-9]{12}:.+", var.interruption_queue_arn))
    error_message = "interruption_queue_arn must be an SQS queue ARN."
  }
}

variable "role_name" {
  description = "IAM role name for the Karpenter controller service account."
  type        = string
  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.role_name))
    error_message = "role_name must be a valid IAM role name of 1-64 characters."
  }
}

variable "namespace" {
  type    = string
  default = "kube-system"
}

variable "service_account_name" {
  type    = string
  default = "karpenter"
}

variable "tags" {
  type    = map(string)
  default = {}
}
