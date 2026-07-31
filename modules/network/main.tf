locals {
  common_tags = merge(var.tags, { "managed-by" = "terraform" })
  slot_azs = flatten([
    for slot, cidrs in var.subnet_cidrs : [
      for az in var.availability_zones : {
        key          = "${slot}/${az}"
        slot         = slot
        az           = az
        public_cidr  = cidrs.public[az]
        private_cidr = cidrs.private[az]
      }
    ]
  ])
  slot_az_map = { for subnet in local.slot_azs : subnet.key => subnet }
  nat_azs = {
    for slot, cidrs in var.subnet_cidrs : slot => (
      var.nat_gateway_mode == "per_az" ? var.availability_zones : [var.availability_zones[0]]
    )
  }
  nat_gateways = merge([
    for slot, azs in local.nat_azs : {
      for az in azs : "${slot}/${az}" => { slot = slot, az = az }
    }
  ]...)
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, { Name = "${var.name}-vpc" })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_subnet" "public" {
  for_each = local.slot_az_map

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.public_cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name                     = "${var.name}-${each.value.slot}-public-${each.value.az}"
    "cluster-slot"           = each.value.slot
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateways
  domain   = "vpc"
  tags     = merge(local.common_tags, { Name = "${var.name}-${each.value.slot}-nat-${each.value.az}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = local.nat_gateways
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags       = merge(local.common_tags, { Name = "${var.name}-${each.value.slot}-nat-${each.value.az}" })
  depends_on = [aws_internet_gateway.this]
}

resource "aws_subnet" "private" {
  for_each = local.slot_az_map

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.private_cidr
  availability_zone = each.value.az

  tags = merge(local.common_tags, {
    Name                              = "${var.name}-${each.value.slot}-private-${each.value.az}"
    "cluster-slot"                    = each.value.slot
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_route_table" "private" {
  for_each = local.slot_az_map
  vpc_id   = aws_vpc.this.id
  tags     = merge(local.common_tags, { Name = "${var.name}-${each.value.slot}-private-${each.value.az}" })
}

resource "aws_route" "private_nat" {
  for_each = local.slot_az_map

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this[
    "${each.value.slot}/${var.nat_gateway_mode == "per_az" ? each.value.az : var.availability_zones[0]}"
  ].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
