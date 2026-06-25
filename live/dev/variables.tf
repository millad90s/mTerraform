# ---- Provider connection ----
variable "vsphere_user" {
  type    = string
  default = null
}
variable "vsphere_password" {
  type      = string
  default   = null
  sensitive = true
}
variable "vsphere_server" {
  type    = string
  default = null
}

variable "proxmox_endpoint" {
  type    = string
  default = null
}
variable "proxmox_api_token" {
  type      = string
  default   = null
  sensitive = true
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "gcp_project_id" {
  type    = string
  default = null
}
variable "gcp_region" {
  type    = string
  default = "europe-west3"
}

variable "openstack_auth_url" {
  type    = string
  default = null
}
variable "openstack_region" {
  type    = string
  default = "RegionOne"
}
variable "openstack_tenant_name" {
  type    = string
  default = null
}

# ---- Feature toggles (keep on-prem off in cloud CI, etc.) ----
variable "enable_vsphere" {
  type    = bool
  default = false
}
variable "enable_proxmox" {
  type    = bool
  default = false
}
variable "enable_openstack" {
  type    = bool
  default = false
}
variable "enable_eks" {
  type    = bool
  default = false
}
# GKE is the always-on cloud target in dev (the helm/kubernetes providers point
# at it), so it has no toggle. Set node_pools to {} to run a control-plane only.
