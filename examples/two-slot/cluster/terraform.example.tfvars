# Copy to terraform.tfvars. Pass values from the network state through your
# chosen remote-state mechanism; do not commit account-specific identifiers.
aws_region         = "ap-northeast-2"
cluster_name       = "example-eks-blue"
cluster_version    = "1.35"
vpc_id             = "vpc-REPLACE_ME"
private_subnet_ids = ["subnet-REPLACE_ME_A", "subnet-REPLACE_ME_B"]
