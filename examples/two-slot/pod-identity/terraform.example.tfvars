# Copy to terraform.tfvars. Verify the agent version against the target EKS
# Kubernetes version before applying. The IAM role trust policy and service
# account are managed outside this example.
aws_region          = "ap-northeast-2"
cluster_name        = "example-eks-blue"
agent_addon_version = "v1.0.0-eksbuild.1"

associations = {
  example = {
    namespace            = "example"
    service_account_name = "example-workload"
    role_arn             = "arn:aws:iam::123456789012:role/REPLACE_ME"
  }
}
