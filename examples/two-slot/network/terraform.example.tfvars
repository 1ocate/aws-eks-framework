# Copy to terraform.tfvars and choose an AWS Region available to your account.
aws_region = "ap-northeast-2"
name       = "example-eks"

# Keep both slots for blue/green replacement. To use an in-place strategy,
# remove the green entry and create only one cluster root from its outputs.
subnet_cidrs = {
  blue = {
    public  = { ap-northeast-2a = "10.40.0.0/24", ap-northeast-2b = "10.40.1.0/24" }
    private = { ap-northeast-2a = "10.40.10.0/24", ap-northeast-2b = "10.40.11.0/24" }
  }
  green = {
    public  = { ap-northeast-2a = "10.40.2.0/24", ap-northeast-2b = "10.40.3.0/24" }
    private = { ap-northeast-2a = "10.40.12.0/24", ap-northeast-2b = "10.40.13.0/24" }
  }
}
