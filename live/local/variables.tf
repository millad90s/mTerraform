variable "vm_name" {
  description = "Name of the VM."
  type        = string
  default     = "dev-app-01"
}

variable "cpus" {
  description = "Number of vCPUs."
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory size (e.g. 2G)."
  type        = string
  default     = "2G"
}

variable "disk" {
  description = "Disk size (e.g. 10G)."
  type        = string
  default     = "10G"
}

variable "image" {
  description = "Multipass image alias (e.g. 24.04)."
  type        = string
  default     = "24.04"
}
