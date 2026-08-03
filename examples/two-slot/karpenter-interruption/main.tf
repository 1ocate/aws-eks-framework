provider "aws" {
  region = var.aws_region
}

module "karpenter_interruption" {
  source = "../../../modules/eks-karpenter-interruption"

  resource_name_prefix = var.resource_name_prefix
  tags                 = { environment = "example" }
}
