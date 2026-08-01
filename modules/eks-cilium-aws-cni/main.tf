resource "helm_release" "this" {
  name             = var.release_name
  repository       = "oci://quay.io/cilium/charts"
  chart            = "cilium"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = false
  atomic           = true
  cleanup_on_fail  = true
  wait             = true
  timeout          = var.timeout_seconds

  set = [
    {
      name  = "cni.chainingMode"
      value = "aws-cni"
    },
    {
      name  = "cni.exclusive"
      value = "false"
    },
    {
      name  = "enableIPv4Masquerade"
      value = "false"
    },
    {
      name  = "routingMode"
      value = "native"
    },
    {
      name  = "operator.replicas"
      value = tostring(var.operator_replicas)
    },
  ]
}
