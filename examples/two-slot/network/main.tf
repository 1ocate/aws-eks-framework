module "network" {
  source = "../../../modules/network"

  name               = var.name
  vpc_cidr           = "10.40.0.0/16"
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  nat_gateway_mode   = "single"

  subnet_cidrs = var.subnet_cidrs

  tags = { environment = "example" }
}
