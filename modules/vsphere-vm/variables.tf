variable "name" {
  description = "Name of the virtual machine."
  type        = string
}

variable "datacenter" {
  description = "vSphere datacenter name."
  type        = string
}

variable "cluster" {
  description = "Compute cluster the VM is scheduled on."
  type        = string
}

variable "datastore" {
  description = "Datastore that backs the VM's disks."
  type        = string
}

variable "network" {
  description = "Port group / network the VM attaches to."
  type        = string
}

variable "template" {
  description = "Name of the VM template to clone from."
  type        = string
}

variable "folder" {
  description = "Inventory folder for the VM (empty = datacenter root)."
  type        = string
  default     = ""
}

variable "num_cpus" {
  description = "Number of vCPUs."
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Memory in MB."
  type        = number
  default     = 4096
}

variable "disks" {
  description = "Additional data disks (the OS disk comes from the template)."
  type = list(object({
    label   = string
    size_gb = number
    thin    = optional(bool, true)
    eagerly = optional(bool, false)
  }))
  default = []
}

variable "ipv4_address" {
  description = "Static IPv4 address. Leave null for DHCP."
  type        = string
  default     = null
}

variable "ipv4_netmask" {
  description = "IPv4 netmask bits (e.g. 24). Required when ipv4_address is set."
  type        = number
  default     = 24
}

variable "ipv4_gateway" {
  description = "Default gateway. Required when ipv4_address is set."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "DNS servers for guest customization."
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "domain" {
  description = "DNS domain for the guest."
  type        = string
  default     = "local"
}

variable "tags" {
  description = "vSphere tag IDs to attach to the VM."
  type        = list(string)
  default     = []
}
