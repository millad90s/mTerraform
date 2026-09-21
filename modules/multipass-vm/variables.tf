variable "name" {
  description = "Name of the VM."
  type        = string
}

variable "image" {
  description = "Multipass image alias or URL (e.g. 24.04, 22.04)."
  type        = string
  default     = "24.04"
}

variable "cpus" {
  description = "Number of vCPUs."
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory size with unit (e.g. 2G)."
  type        = string
  default     = "2G"
}

variable "disk" {
  description = "Disk size with unit (e.g. 10G)."
  type        = string
  default     = "10G"
}

variable "cloud_init" {
  description = "Cloud-init user-data content. Null means none."
  type        = string
  default     = null
}

variable "ssh_public_keys" {
  description = "SSH public keys added to the default user via cloud-init. Ignored if cloud_init is set."
  type        = list(string)
  default     = []
}
