variable "aws_region" {
  description = "AWS Region containing the target EKS cluster."
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name used by the AWS CLI authentication exec plugin."
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS API endpoint output from the separately managed cluster root."
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "Base64-encoded EKS cluster CA output from the separately managed cluster root."
  type        = string
  sensitive   = true
}

variable "chart_version" {
  description = "Exact Argo CD Helm chart version."
  type        = string
  default     = "10.2.1"
}

variable "high_availability" {
  description = "Whether to enable the Argo CD HA topology; requires at least three worker nodes."
  type        = bool
  default     = false
}
