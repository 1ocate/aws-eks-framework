variable "resource_name_prefix" {
  description = "Prefix used for the interruption queue and EventBridge rule names."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_-]{1,20}$", var.resource_name_prefix))
    error_message = "resource_name_prefix must be 1-20 letters, numbers, hyphens, or underscores."
  }
}

variable "message_retention_seconds" {
  description = "SQS message retention period for interruption events."
  type        = number
  default     = 300

  validation {
    condition     = var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600
    error_message = "message_retention_seconds must be between 60 and 1209600."
  }
}

variable "visibility_timeout_seconds" {
  description = "SQS visibility timeout used while Karpenter processes an interruption event."
  type        = number
  default     = 30

  validation {
    condition     = var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200
    error_message = "visibility_timeout_seconds must be between 0 and 43200."
  }
}

variable "tags" {
  description = "Additional tags applied to interruption resources."
  type        = map(string)
  default     = {}
}
