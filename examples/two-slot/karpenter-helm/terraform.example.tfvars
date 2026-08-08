aws_region              = "ap-northeast-2"
cluster_name            = "example-eks-blue"
interruption_queue_name = "example-eks-blue-karpenter-interruption"
iam_role_arn            = "arn:aws:iam::123456789012:role/example-eks-blue-karpenter-controller"
chart_version           = "1.14.0"
enable_zonal_shift      = false
isolated_vpc            = false
