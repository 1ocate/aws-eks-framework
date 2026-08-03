variable "aws_region" {
  type = string
}

variable "resource_name_prefix" {
  description = "Neutral, short prefix for queue and EventBridge rule names."
  type        = string
}
