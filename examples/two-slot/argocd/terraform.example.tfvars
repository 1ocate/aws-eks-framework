# Copy to terraform.tfvars. Pass the outputs from blue-cluster or green-cluster
# through a secure configuration mechanism; do not commit real values.
aws_region                         = "ap-northeast-2"
cluster_name                       = "example-eks-blue"
cluster_endpoint                   = "https://REPLACE_ME.eks.amazonaws.com"
cluster_certificate_authority_data = "REPLACE_ME_BASE64_CA"
chart_version                      = "10.2.1"

# The two-node cluster example is intentionally not large enough for Argo CD HA.
high_availability = false
