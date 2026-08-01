module "eks" {
  source = "../../../modules/eks"

  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids

  # Keep the API private by default. Set this true only with narrowly scoped CIDRs.
  endpoint_public_access = false

  node_groups = {
    system = {
      instance_types = ["t3.large"]
      capacity_type  = "ON_DEMAND"
      min_size       = 2
      desired_size   = 2
      max_size       = 3
      labels         = { workload = "system" }
    }
  }

  tags = { environment = "example" }
}
