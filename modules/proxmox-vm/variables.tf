variable "name" {
  description = "Name of the VM."
  type        = string
}

variable "node_name" {
  description = "Proxmox node the VM runs on."
  type        = string
}

variable "vm_id" {
  description = "Explicit VMID. Null lets Proxmox assign one."
  type        = number
  default     = null
}

variable "description" {
  description = "Free-form description shown in the Proxmox UI."
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "Tags applied to the VM."
  type        = list(string)
  default     = ["terraform"]
}

variable "clone_template_id" {
  description = "VMID of the template to clone from."
  type        = number
}

variable "cores" {
  description = "Number of CPU cores."
  type        = number
  default     = 2
}

variable "sockets" {
  description = "Number of CPU sockets."
  type        = number
  default     = 1
}

variable "memory_mb" {
  description = "Dedicated memory in MB."
  type        = number
  default     = 2048
}

variable "disk" {
  description = "Primary disk configuration."
  type = object({
    datastore_id = string
    size_gb      = number
    interface    = optional(string, "scsi0")
    discard      = optional(string, "on")
  })
}

variable "network_bridge" {
  description = "Linux/OVS bridge to attach the primary NIC to."
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN tag for the NIC (null = untagged)."
  type        = number
  default     = null
}

variable "ip_config" {
  description = "Cloud-init IP config. Use 'dhcp' or CIDR like '10.0.0.5/24'."
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  description = "Cloud-init default gateway (only with static ip_config)."
  type        = string
  default     = null
}

variable "ci_user" {
  description = "Cloud-init default user."
  type        = string
  default     = "ubuntu"
}

variable "ssh_public_keys" {
  description = "SSH public keys injected via cloud-init."
  type        = list(string)
  default     = []
}
