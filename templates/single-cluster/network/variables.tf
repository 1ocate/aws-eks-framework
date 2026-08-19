variable "aws_region" {
  description = "AWS Region for this environment."
  type        = string
}

variable "name" {
  description = "Network resource-name prefix."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR selected by the user."
  type        = string
}

variable "availability_zones" {
  description = "At least two Availability Zones."
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "Public and private CIDRs for the single primary cluster slot."
  type = map(object({
    public  = map(string)
    private = map(string)
  }))
}

variable "nat_gateway_mode" {
  description = "NAT topology: single or per_az."
  type        = string
  default     = "single"
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
