variable "aws_region" {
  description = "AWS Region for this example environment."
  type        = string
}

variable "cluster_name" {
  description = "Name for the green EKS cluster slot."
  type        = string
}

variable "cluster_version" {
  description = "Pinned EKS Kubernetes minor version selected by the consumer."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from the separately managed network state."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the green slot from the separately managed network state."
  type        = list(string)
}
