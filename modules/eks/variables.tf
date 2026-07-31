variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9_-]{0,99}$", var.cluster_name))
    error_message = "cluster_name must be 1-100 EKS-compatible characters."
  }
}

variable "cluster_version" {
  description = "Pinned EKS Kubernetes version."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID in which the cluster runs."
  type        = string
}

variable "private_subnet_ids" {
  description = "At least two private subnet IDs in distinct Availability Zones."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2 && length(var.private_subnet_ids) == length(toset(var.private_subnet_ids))
    error_message = "private_subnet_ids must contain at least two unique subnets."
  }
}

variable "endpoint_public_access" {
  description = "Whether to expose the Kubernetes API endpoint publicly."
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "Explicit CIDRs allowed to reach a public API endpoint."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.public_access_cidrs : can(cidrhost(cidr, 0))])
    error_message = "public_access_cidrs must contain only valid CIDR blocks."
  }
}

variable "node_groups" {
  description = "Managed node groups used for system workloads and bootstrap capacity."
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    min_size       = number
    desired_size   = number
    max_size       = number
    disk_size      = optional(number, 50)
    labels         = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for group in values(var.node_groups) :
      group.min_size >= 0 && group.min_size <= group.desired_size && group.desired_size <= group.max_size &&
      contains(["ON_DEMAND", "SPOT"], group.capacity_type)
    ])
    error_message = "Each node group must have min_size <= desired_size <= max_size and capacity_type ON_DEMAND or SPOT."
  }
}

variable "addons" {
  description = "Pinned EKS add-on versions, keyed by add-on name."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
