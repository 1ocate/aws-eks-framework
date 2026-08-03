locals {
  managed_policy_arns = concat(
    [
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly",
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    ],
    var.attach_vpc_cni_policy ? ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"] : [],
    var.additional_policy_arns,
  )
  common_tags = merge(var.tags, { "managed-by" = "terraform" })
}

resource "aws_iam_role" "this" {
  name = var.node_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(local.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_eks_access_entry" "this" {
  cluster_name  = var.cluster_name
  principal_arn = aws_iam_role.this.arn
  type          = "EC2_LINUX"
  tags          = local.common_tags
}
