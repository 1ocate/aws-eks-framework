resource "helm_release" "this" {
  name             = var.release_name
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  wait             = true
  timeout          = var.timeout_seconds

  set = [
    {
      name  = "settings.clusterName"
      value = var.cluster_name
    },
    {
      name  = "settings.interruptionQueue"
      value = var.interruption_queue_name
    },
    {
      name  = "settings.enableZonalShift"
      value = tostring(var.enable_zonal_shift)
    },
    {
      name  = "settings.isolatedVPC"
      value = tostring(var.isolated_vpc)
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = var.service_account_name
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = var.iam_role_arn
    },
    {
      name  = "controller.resources.requests.cpu"
      value = var.controller_cpu_request
    },
    {
      name  = "controller.resources.requests.memory"
      value = var.controller_memory_request
    },
    {
      name  = "controller.resources.limits.cpu"
      value = var.controller_cpu_limit
    },
    {
      name  = "controller.resources.limits.memory"
      value = var.controller_memory_limit
    },
  ]
}
