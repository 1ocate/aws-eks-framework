# Copy to terraform.tfvars. Pass values from the network state through your
# chosen secure configuration mechanism; do not commit account-specific IDs.
aws_region         = "ap-northeast-2"
cluster_name       = "example-eks-green"
cluster_version    = "1.35"
vpc_id             = "vpc-REPLACE_ME"
private_subnet_ids = ["subnet-REPLACE_ME_A", "subnet-REPLACE_ME_B"]
