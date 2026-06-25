variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "name" {
  description = "Name of the GKE cluster."
  type        = string
}

variable "region" {
  description = "Region for a regional cluster (or the zone's region)."
  type        = string
  default     = "europe-west3"
}

variable "network" {
  description = "VPC network self-link or name."
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork self-link or name."
  type        = string
  default     = "default"
}

variable "release_channel" {
  description = "GKE release channel: RAPID | REGULAR | STABLE."
  type        = string
  default     = "REGULAR"
}

variable "pods_range_name" {
  description = "Secondary range name for pods (VPC-native). Empty = let GKE manage."
  type        = string
  default     = ""
}

variable "services_range_name" {
  description = "Secondary range name for services. Empty = let GKE manage."
  type        = string
  default     = ""
}

variable "master_ipv4_cidr_block" {
  description = "CIDR for the private control plane (private clusters only)."
  type        = string
  default     = "172.16.0.0/28"
}

variable "enable_private_nodes" {
  description = "Whether nodes get only internal IPs."
  type        = bool
  default     = true
}

variable "node_pools" {
  description = "Node pool definitions, keyed by name."
  type = map(object({
    machine_type   = string
    min_node_count = number
    max_node_count = number
    disk_size_gb   = optional(number, 50)
    disk_type      = optional(string, "pd-balanced")
    preemptible    = optional(bool, false)
    spot           = optional(bool, false)
    labels         = optional(map(string), {})
  }))
  default = {}
}

variable "resource_labels" {
  description = "Labels applied to the cluster."
  type        = map(string)
  default     = {}
}
