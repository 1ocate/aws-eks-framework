output "controller_role_arn" {
  value = module.karpenter_controller_irsa.role_arn
}
