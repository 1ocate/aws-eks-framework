variable "name" {
  description = "Prefix used for network resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,40}[a-z0-9]$", var.name))
    error_message = "name must be 3-42 lowercase alphanumeric or hyphen characters, starting and ending with alphanumeric characters."
  }
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability Zones used by every cluster slot. Use at least two AZs."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2 && length(var.availability_zones) == length(toset(var.availability_zones))
    error_message = "availability_zones must contain at least two unique Availability Zones."
  }
}

variable "subnet_cidrs" {
  description = "CIDRs keyed by cluster slot then AZ. Supply one slot for in-place operations or multiple slots for replacement workflows."
  type = map(object({
    public  = map(string)
    private = map(string)
  }))

  validation {
    condition     = length(var.subnet_cidrs) >= 1
    error_message = "subnet_cidrs must define at least one cluster slot."
  }

  validation {
    condition = alltrue([
      for slot in values(var.subnet_cidrs) :
      length(keys(slot.public)) == length(var.availability_zones) &&
      length(keys(slot.private)) == length(var.availability_zones) &&
      length(setsubtract(toset(keys(slot.public)), toset(var.availability_zones))) == 0 &&
      length(setsubtract(toset(var.availability_zones), toset(keys(slot.public)))) == 0 &&
      length(setsubtract(toset(keys(slot.private)), toset(var.availability_zones))) == 0 &&
      length(setsubtract(toset(var.availability_zones), toset(keys(slot.private)))) == 0
    ])
    error_message = "Every slot must provide public and private CIDRs for exactly all availability_zones."
  }

  validation {
    condition = alltrue(flatten([
      for slot in values(var.subnet_cidrs) : concat(
        [for cidr in values(slot.public) : can(cidrhost(cidr, 0))],
        [for cidr in values(slot.private) : can(cidrhost(cidr, 0))],
      )
    ]))
    error_message = "All subnet CIDRs must be valid IPv4 CIDR blocks."
  }
}

variable "nat_gateway_mode" {
  description = "NAT Gateway topology for each slot: single (lower cost) or per_az (higher availability)."
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be either single or per_az."
  }
}

variable "tags" {
  description = "Additional tags applied to all resources."
  type        = map(string)
  default     = {}
}
