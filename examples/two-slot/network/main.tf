module "network" {
  source = "../../../modules/network"

  name               = var.name
  vpc_cidr           = "10.40.0.0/16"
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  nat_gateway_mode   = "single"

  subnet_cidrs = {
    blue = {
      public  = { "${var.aws_region}a" = "10.40.0.0/24", "${var.aws_region}b" = "10.40.1.0/24" }
      private = { "${var.aws_region}a" = "10.40.10.0/24", "${var.aws_region}b" = "10.40.11.0/24" }
    }
    green = {
      public  = { "${var.aws_region}a" = "10.40.2.0/24", "${var.aws_region}b" = "10.40.3.0/24" }
      private = { "${var.aws_region}a" = "10.40.12.0/24", "${var.aws_region}b" = "10.40.13.0/24" }
    }
  }

  tags = { environment = "example" }
}
