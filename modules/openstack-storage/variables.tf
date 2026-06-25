variable "volumes" {
  description = "Cinder block volumes to create, keyed by a logical name."
  type = map(object({
    size_gb           = number
    description       = optional(string, "Managed by Terraform")
    volume_type       = optional(string) # e.g. "ssd", "ceph"
    availability_zone = optional(string)
    image_id          = optional(string) # create a bootable volume from an image
    metadata          = optional(map(string), {})

    # Optional attachment: set instance_id to attach this volume to a server.
    instance_id = optional(string)
    device      = optional(string) # e.g. "/dev/vdb"
  }))
  default = {}
}
