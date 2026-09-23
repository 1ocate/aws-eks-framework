variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "addon_version" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
