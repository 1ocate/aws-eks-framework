variable "aws_region" {
  description = "AWS Region for this example environment."
  type        = string
}

variable "name" {
  description = "Neutral environment name used as the resource prefix."
  type        = string
}

variable "subnet_cidrs" {
  description = "One slot for in-place upgrades, or two or more slots for a replacement workflow."
  type = map(object({
    public  = map(string)
    private = map(string)
  }))
}
