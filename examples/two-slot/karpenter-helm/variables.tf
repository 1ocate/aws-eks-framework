variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "interruption_queue_name" {
  description = "eks-karpenter-interruption module output queue name."
  type        = string
}

variable "iam_role_arn" {
  description = "eks-karpenter-controller-irsa module output role ARN."
  type        = string
}

variable "chart_version" {
  type    = string
  default = "1.14.0"
}

variable "enable_zonal_shift" {
  type    = bool
  default = false
}

variable "isolated_vpc" {
  type    = bool
  default = false
}
