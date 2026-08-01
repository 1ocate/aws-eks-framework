variable "cluster_name" { type = string }
variable "oidc_provider_arn" { type = string }
variable "oidc_provider_url" { type = string }
variable "iam_policy_arn" {
  description = "Customer-managed IAM policy ARN built from the controller-release-specific upstream policy."
  type        = string
  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:policy/.+", var.iam_policy_arn))
    error_message = "iam_policy_arn must be a customer-managed IAM policy ARN."
  }
}
variable "role_name" {
  type    = string
  default = null
}
variable "namespace" {
  type    = string
  default = "kube-system"
}
variable "service_account_name" {
  type    = string
  default = "aws-load-balancer-controller"
}
variable "tags" {
  type    = map(string)
  default = {}
}
