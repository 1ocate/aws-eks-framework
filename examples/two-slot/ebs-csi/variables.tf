variable "aws_region" {
  description = "AWS Region of the target EKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "Name of the target EKS cluster."
  type        = string
}

variable "oidc_provider_arn" {
  description = "oidc_provider_arn output from the cluster root module."
  type        = string
}

variable "oidc_provider_url" {
  description = "oidc_provider_url output from the cluster root module."
  type        = string
}

variable "addon_version" {
  description = "Pinned EBS CSI add-on version compatible with the target EKS version."
  type        = string
}
