variable "hostname" {
  description = "Hostname of the container."
  type        = string
}

variable "node_name" {
  description = "Proxmox node the container runs on."
  type        = string
}

variable "vm_id" {
  description = "Explicit container ID. Null lets Proxmox assign one."
  type        = number
  default     = null
}

variable "description" {
  description = "Free-form description shown in the Proxmox UI."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Tags applied to the container."
  type        = list(string)
  default     = ["terraform", "lxc"]
}

variable "unprivileged" {
  description = "Whether to create an unprivileged container."
  type        = bool
  default     = true
}

variable "template_file_id" {
  description = "Datastore file ID of the OS template (e.g. 'local:vztmpl/...')."
  type        = string
}

variable "os_type" {
  description = "Container OS type (ubuntu, debian, alpine, ...)."
  type        = string
  default     = "ubuntu"
}

variable "cores" {
  description = "CPU cores allocated to the container."
  type        = number
  default     = 1
}

variable "memory_mb" {
  description = "Memory in MB."
  type        = number
  default     = 512
}

variable "swap_mb" {
  description = "Swap in MB."
  type        = number
  default     = 512
}

variable "disk" {
  description = "Root filesystem configuration."
  type = object({
    datastore_id = string
    size_gb      = number
  })
}

variable "network_bridge" {
  description = "Bridge to attach the container NIC to."
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN tag for the NIC (null = untagged)."
  type        = number
  default     = null
}

variable "ip_config" {
  description = "IP config. Use 'dhcp' or CIDR like '10.0.0.5/24'."
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "Default gateway (only with static ip_config)."
  type        = string
  default     = null
}

variable "ssh_public_keys" {
  description = "SSH public keys (newline-joined) for the root user."
  type        = list(string)
  default     = []
}
