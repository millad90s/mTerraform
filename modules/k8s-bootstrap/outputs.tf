output "ingress_nginx_namespace" {
  description = "Namespace where ingress-nginx was installed (if enabled)."
  value       = local.ingress.enabled ? local.ingress.namespace : null
}

output "cert_manager_namespace" {
  description = "Namespace where cert-manager was installed (if enabled)."
  value       = local.cert.enabled ? local.cert.namespace : null
}

output "argocd_namespace" {
  description = "Namespace where Argo CD was installed (if enabled)."
  value       = local.argo.enabled ? local.argo.namespace : null
}

output "falco_namespace" {
  description = "Namespace where Falco was installed (if enabled)."
  value       = local.falco.enabled ? local.falco.namespace : null
}
