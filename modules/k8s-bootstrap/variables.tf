# NOTE: configure the `helm` and `kubernetes` providers in the calling stack and
# point them at the target cluster (EKS/GKE). This module only installs charts.

variable "ingress_nginx" {
  description = "ingress-nginx install toggle and version."
  type = object({
    enabled       = optional(bool, true)
    chart_version = optional(string, "4.11.2")
    namespace     = optional(string, "ingress-nginx")
    service_type  = optional(string, "LoadBalancer")
    extra_set     = optional(map(string), {})
  })
  default = {}
}

variable "cert_manager" {
  description = "cert-manager install toggle and version."
  type = object({
    enabled       = optional(bool, true)
    chart_version = optional(string, "v1.15.3")
    namespace     = optional(string, "cert-manager")
  })
  default = {}
}

variable "argocd" {
  description = "Argo CD install toggle and version."
  type = object({
    enabled       = optional(bool, false)
    chart_version = optional(string, "7.6.12")
    namespace     = optional(string, "argocd")
  })
  default = {}
}
