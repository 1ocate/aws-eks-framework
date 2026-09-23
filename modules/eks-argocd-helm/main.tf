resource "helm_release" "this" {
  name             = var.release_name
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.chart_version
  namespace        = var.namespace
  create_namespace = true
  atomic           = true
  cleanup_on_fail  = true
  wait             = true
  timeout          = var.timeout_seconds

  set = concat(
    [
      {
        name  = "server.service.type"
        value = "ClusterIP"
      },
      {
        name  = "server.ingress.enabled"
        value = "false"
      },
    ],
    var.high_availability ? [
      {
        name  = "redis-ha.enabled"
        value = "true"
      },
      {
        name  = "controller.replicas"
        value = "1"
      },
      {
        name  = "server.replicas"
        value = "2"
      },
      {
        name  = "repoServer.replicas"
        value = "2"
      },
      {
        name  = "applicationSet.replicas"
        value = "2"
      },
    ] : [],
  )
}
