output "vpc_id" {
  description = "ID of the VPC that contains every slot subnet."
  value       = aws_vpc.this.id
}

output "private_subnet_ids_by_slot" {
  description = "Private subnet IDs keyed by cluster slot and Availability Zone."
  value = {
    for slot in keys(var.subnet_cidrs) : slot => {
      for az in var.availability_zones : az => aws_subnet.private["${slot}/${az}"].id
    }
  }
}

output "public_subnet_ids_by_slot" {
  description = "Public subnet IDs keyed by cluster slot and Availability Zone."
  value = {
    for slot in keys(var.subnet_cidrs) : slot => {
      for az in var.availability_zones : az => aws_subnet.public["${slot}/${az}"].id
    }
  }
}
