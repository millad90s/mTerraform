locals {
  ingress = merge({
    enabled       = true
    chart_version = "4.11.2"
    namespace     = "ingress-nginx"
    service_type  = "LoadBalancer"
    extra_set     = {}
  }, var.ingress_nginx)

  cert = merge({
    enabled       = true
    chart_version = "v1.15.3"
    namespace     = "cert-manager"
  }, var.cert_manager)

  argo = merge({
    enabled       = false
    chart_version = "7.6.12"
    namespace     = "argocd"
  }, var.argocd)
}

resource "helm_release" "ingress_nginx" {
  count = local.ingress.enabled ? 1 : 0

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = local.ingress.chart_version
  namespace        = local.ingress.namespace
  create_namespace = true

  set {
    name  = "controller.service.type"
    value = local.ingress.service_type
  }

  dynamic "set" {
    for_each = local.ingress.extra_set
    content {
      name  = set.key
      value = set.value
    }
  }
}

resource "helm_release" "cert_manager" {
  count = local.cert.enabled ? 1 : 0

  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = local.cert.chart_version
  namespace        = local.cert.namespace
  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }
}

resource "helm_release" "argocd" {
  count = local.argo.enabled ? 1 : 0

  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = local.argo.chart_version
  namespace        = local.argo.namespace
  create_namespace = true
}
