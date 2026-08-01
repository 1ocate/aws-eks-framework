# Copy to terraform.tfvars. Obtain the cluster and OIDC values from the
# separately managed cluster root state. Verify add-on compatibility first:
# aws eks describe-addon-versions --kubernetes-version <version> --addon-name aws-ebs-csi-driver
aws_region        = "ap-northeast-2"
cluster_name      = "example-eks-blue"
oidc_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.ap-northeast-2.amazonaws.com/id/REPLACE_ME"
oidc_provider_url = "https://oidc.eks.ap-northeast-2.amazonaws.com/id/REPLACE_ME"
addon_version     = "v1.47.0-eksbuild.1"
