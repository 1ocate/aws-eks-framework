variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "chart_version" {
  type    = string
  default = "1.19.6"
}

variable "operator_replicas" {
  type    = number
  default = 2
}
