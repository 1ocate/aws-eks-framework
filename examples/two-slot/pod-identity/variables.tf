variable "aws_region" {
  description = "AWS Region of the target EKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "Name of the target EKS cluster."
  type        = string
}

variable "agent_addon_version" {
  description = "Pinned Pod Identity Agent version compatible with the target EKS version."
  type        = string
}

variable "associations" {
  description = "Pod Identity associations for service accounts managed outside this example."
  type = map(object({
    namespace            = string
    service_account_name = string
    role_arn             = string
  }))
  default = {}
}
