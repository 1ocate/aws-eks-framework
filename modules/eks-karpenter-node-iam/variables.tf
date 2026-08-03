variable "cluster_name" {
  description = "EKS cluster name with authentication mode API or API_AND_CONFIG_MAP."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9_-]{0,99}$", var.cluster_name))
    error_message = "cluster_name must be 1-100 EKS-compatible characters."
  }
}

variable "node_role_name" {
  description = "IAM role name used by Karpenter-provisioned Linux nodes."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9+=,.@_-]{1,64}$", var.node_role_name))
    error_message = "node_role_name must be a valid IAM role name of 1-64 characters."
  }
}

variable "attach_vpc_cni_policy" {
  description = "Whether to attach AmazonEKS_CNI_Policy when AWS VPC CNI has no separate pod identity or IRSA role."
  type        = bool
  default     = true
}

variable "additional_policy_arns" {
  description = "Additional managed IAM policy ARNs required by node workloads."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for policy_arn in var.additional_policy_arns :
      can(regex("^arn:aws:iam::([0-9]{12}|aws):policy/.+", policy_arn))
    ])
    error_message = "additional_policy_arns must contain IAM managed policy ARNs."
  }
}

variable "tags" {
  description = "Additional tags applied to the node role and EKS access entry."
  type        = map(string)
  default     = {}
}
