variable "datacenter" {
  description = "vSphere datacenter name."
  type        = string
}

variable "host" {
  description = "ESXi host that owns the storage (for iSCSI/NAS mounts)."
  type        = string
}

variable "nas_datastores" {
  description = "NFS datastores to create and mount."
  type = map(object({
    remote_hosts = list(string)
    remote_path  = string
    access_mode  = optional(string, "readWrite")
    type         = optional(string, "NFS")
  }))
  default = {}
}

variable "vmdk_disks" {
  description = "Standalone VMDK virtual disks to create on a datastore."
  type = map(object({
    datastore = string
    path      = string # e.g. "volumes/data01.vmdk"
    size_gb   = number
    type      = optional(string, "thin") # thin | eagerZeroedThick | lazy
  }))
  default = {}
}
