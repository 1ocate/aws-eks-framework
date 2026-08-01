variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "iam_role_arn" {
  description = "eks-alb-controller-irsa module output role ARN."
  type        = string
}

variable "chart_version" {
  type    = string
  default = "1.14.0"
}

variable "enable_service_mutator_webhook" {
  type    = bool
  default = false
}
