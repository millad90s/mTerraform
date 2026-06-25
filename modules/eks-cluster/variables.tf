variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes control-plane version."
  type        = string
  default     = "1.30"
}

variable "subnet_ids" {
  description = "Subnet IDs for the cluster and node groups (mix of private/public)."
  type        = list(string)
}

variable "endpoint_public_access" {
  description = "Whether the API server endpoint is publicly reachable."
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public API endpoint."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enabled_log_types" {
  description = "Control-plane log types to ship to CloudWatch."
  type        = list(string)
  default     = ["api", "audit", "authenticator"]
}

variable "node_groups" {
  description = "Managed node group definitions, keyed by name."
  type = map(object({
    instance_types = list(string)
    capacity_type  = optional(string, "ON_DEMAND") # ON_DEMAND | SPOT
    desired_size   = number
    min_size       = number
    max_size       = number
    disk_size_gb   = optional(number, 50)
    labels         = optional(map(string), {})
  }))
  default = {}
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
