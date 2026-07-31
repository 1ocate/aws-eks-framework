output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnet_ids_by_slot" {
  value = module.network.private_subnet_ids_by_slot
}
