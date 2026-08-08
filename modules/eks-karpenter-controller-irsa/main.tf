data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "current" {}

locals {
  account_id      = data.aws_caller_identity.current.account_id
  partition       = data.aws_partition.current.partition
  region          = data.aws_region.current.name
  issuer_host     = trimprefix(var.oidc_provider_url, "https://")
  cluster_tag     = "kubernetes.io/cluster/${var.cluster_name}"
  common_tags     = merge(var.tags, { "managed-by" = "terraform" })
  ec2_region_arn  = "arn:${local.partition}:ec2:${local.region}"
  iam_account_arn = "arn:${local.partition}:iam::${local.account_id}"
}

resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRoleWithWebIdentity"
      Principal = { Federated = var.oidc_provider_arn }
      Condition = {
        StringEquals = {
          "${local.issuer_host}:aud" = "sts.amazonaws.com"
          "${local.issuer_host}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
        }
      }
    }]
  })
  tags = local.common_tags
}

resource "aws_iam_role_policy" "node_lifecycle" {
  name = "${var.role_name}-node-lifecycle"
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "AllowScopedEC2InstanceAccessActions"
        Effect   = "Allow"
        Resource = ["${local.ec2_region_arn}::image/*", "${local.ec2_region_arn}::snapshot/*", "${local.ec2_region_arn}:*:security-group/*", "${local.ec2_region_arn}:*:subnet/*", "${local.ec2_region_arn}:*:capacity-reservation/*", "${local.ec2_region_arn}:*:placement-group/*"]
        Action   = ["ec2:RunInstances", "ec2:CreateFleet"]
      },
      {
        Sid      = "AllowScopedEC2LaunchTemplateAccessActions"
        Effect   = "Allow"
        Resource = "${local.ec2_region_arn}:*:launch-template/*"
        Action   = ["ec2:RunInstances", "ec2:CreateFleet"]
        Condition = {
          StringEquals = { "aws:ResourceTag/${local.cluster_tag}" = "owned" }
          StringLike   = { "aws:ResourceTag/karpenter.sh/nodepool" = "*" }
        }
      },
      {
        Sid      = "AllowScopedEC2InstanceActionsWithTags"
        Effect   = "Allow"
        Resource = ["${local.ec2_region_arn}:*:fleet/*", "${local.ec2_region_arn}:*:instance/*", "${local.ec2_region_arn}:*:volume/*", "${local.ec2_region_arn}:*:network-interface/*", "${local.ec2_region_arn}:*:launch-template/*", "${local.ec2_region_arn}:*:spot-instances-request/*"]
        Action   = ["ec2:RunInstances", "ec2:CreateFleet", "ec2:CreateLaunchTemplate"]
        Condition = {
          StringEquals = { "aws:RequestTag/${local.cluster_tag}" = "owned", "aws:RequestTag/eks:eks-cluster-name" = var.cluster_name }
          StringLike   = { "aws:RequestTag/karpenter.sh/nodepool" = "*" }
        }
      },
      {
        Sid      = "AllowScopedResourceCreationTagging"
        Effect   = "Allow"
        Resource = ["${local.ec2_region_arn}:*:fleet/*", "${local.ec2_region_arn}:*:instance/*", "${local.ec2_region_arn}:*:volume/*", "${local.ec2_region_arn}:*:network-interface/*", "${local.ec2_region_arn}:*:launch-template/*", "${local.ec2_region_arn}:*:spot-instances-request/*"]
        Action   = "ec2:CreateTags"
        Condition = {
          StringEquals = { "aws:RequestTag/${local.cluster_tag}" = "owned", "aws:RequestTag/eks:eks-cluster-name" = var.cluster_name, "ec2:CreateAction" = ["RunInstances", "CreateFleet", "CreateLaunchTemplate"] }
          StringLike   = { "aws:RequestTag/karpenter.sh/nodepool" = "*" }
        }
      },
      {
        Sid      = "AllowScopedResourceTagging"
        Effect   = "Allow"
        Resource = "${local.ec2_region_arn}:*:instance/*"
        Action   = "ec2:CreateTags"
        Condition = {
          StringEquals                = { "aws:ResourceTag/${local.cluster_tag}" = "owned" }
          StringLike                  = { "aws:ResourceTag/karpenter.sh/nodepool" = "*" }
          StringEqualsIfExists        = { "aws:RequestTag/eks:eks-cluster-name" = var.cluster_name }
          "ForAllValues:StringEquals" = { "aws:TagKeys" = ["eks:eks-cluster-name", "karpenter.sh/nodeclaim", "Name"] }
        }
      },
      {
        Sid      = "AllowScopedDeletion"
        Effect   = "Allow"
        Resource = ["${local.ec2_region_arn}:*:instance/*", "${local.ec2_region_arn}:*:launch-template/*"]
        Action   = ["ec2:TerminateInstances", "ec2:DeleteLaunchTemplate"]
        Condition = {
          StringEquals = { "aws:ResourceTag/${local.cluster_tag}" = "owned" }
          StringLike   = { "aws:ResourceTag/karpenter.sh/nodepool" = "*" }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "iam_integration" {
  name = "${var.role_name}-iam-integration"
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowPassingInstanceRole"
        Effect    = "Allow"
        Resource  = var.node_role_arn
        Action    = "iam:PassRole"
        Condition = { StringEquals = { "iam:PassedToService" = ["ec2.amazonaws.com", "ec2.amazonaws.com.cn"] } }
      },
      {
        Sid      = "AllowScopedInstanceProfileCreationActions"
        Effect   = "Allow"
        Resource = "${local.iam_account_arn}:instance-profile/*"
        Action   = "iam:CreateInstanceProfile"
        Condition = {
          StringEquals = { "aws:RequestTag/${local.cluster_tag}" = "owned", "aws:RequestTag/eks:eks-cluster-name" = var.cluster_name, "aws:RequestTag/topology.kubernetes.io/region" = local.region }
          StringLike   = { "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*" }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileTagActions"
        Effect   = "Allow"
        Resource = "${local.iam_account_arn}:instance-profile/*"
        Action   = "iam:TagInstanceProfile"
        Condition = {
          StringEquals = { "aws:ResourceTag/${local.cluster_tag}" = "owned", "aws:ResourceTag/topology.kubernetes.io/region" = local.region, "aws:RequestTag/${local.cluster_tag}" = "owned", "aws:RequestTag/eks:eks-cluster-name" = var.cluster_name, "aws:RequestTag/topology.kubernetes.io/region" = local.region }
          StringLike   = { "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*", "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass" = "*" }
        }
      },
      {
        Sid      = "AllowScopedInstanceProfileActions"
        Effect   = "Allow"
        Resource = "${local.iam_account_arn}:instance-profile/*"
        Action   = ["iam:AddRoleToInstanceProfile", "iam:RemoveRoleFromInstanceProfile", "iam:DeleteInstanceProfile"]
        Condition = {
          StringEquals = { "aws:ResourceTag/${local.cluster_tag}" = "owned", "aws:ResourceTag/topology.kubernetes.io/region" = local.region }
          StringLike   = { "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass" = "*" }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "platform_integration" {
  name = "${var.role_name}-platform-integration"
  role = aws_iam_role.this.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Sid = "AllowAPIServerEndpointDiscovery", Effect = "Allow", Resource = "arn:${local.partition}:eks:${local.region}:${local.account_id}:cluster/${var.cluster_name}", Action = "eks:DescribeCluster" },
      { Sid = "AllowInterruptionQueueActions", Effect = "Allow", Resource = var.interruption_queue_arn, Action = ["sqs:DeleteMessage", "sqs:GetQueueUrl", "sqs:ReceiveMessage"] },
      { Sid = "AllowZonalShiftStatusReadOnly", Effect = "Allow", Resource = "*", Action = "arc-zonal-shift:GetManagedResource", Condition = { StringEquals = { "arc-zonal-shift:ResourceIdentifier" = "arn:${local.partition}:eks:${local.region}:${local.account_id}:cluster/${var.cluster_name}" } } },
      { Sid = "AllowRegionalReadActions", Effect = "Allow", Resource = "*", Action = ["ec2:DescribeCapacityReservations", "ec2:DescribeImages", "ec2:DescribeInstances", "ec2:DescribeInstanceStatus", "ec2:DescribeInstanceTypeOfferings", "ec2:DescribeInstanceTypes", "ec2:DescribeLaunchTemplates", "ec2:DescribePlacementGroups", "ec2:DescribeSecurityGroups", "ec2:DescribeSpotPriceHistory", "ec2:DescribeSubnets"], Condition = { StringEquals = { "aws:RequestedRegion" = local.region } } },
      { Sid = "AllowSSMReadActions", Effect = "Allow", Resource = "arn:${local.partition}:ssm:${local.region}::parameter/aws/service/*", Action = "ssm:GetParameter" },
      { Sid = "AllowPricingReadActions", Effect = "Allow", Resource = "*", Action = "pricing:GetProducts" },
      { Sid = "AllowUnscopedInstanceProfileListAction", Effect = "Allow", Resource = "*", Action = "iam:ListInstanceProfiles" },
      { Sid = "AllowInstanceProfileReadActions", Effect = "Allow", Resource = "${local.iam_account_arn}:instance-profile/*", Action = "iam:GetInstanceProfile" },
    ]
  })
}
