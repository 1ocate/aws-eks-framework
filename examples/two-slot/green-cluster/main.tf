module "cluster" {
  source = "../cluster"

  aws_region         = var.aws_region
  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = var.vpc_id
  private_subnet_ids = var.private_subnet_ids
}
