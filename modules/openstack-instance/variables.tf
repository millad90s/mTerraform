variable "name" {
  description = "Name of the instance."
  type        = string
}

variable "image_name" {
  description = "Name of the Glance image to boot from (ignored when boot_from_volume is set)."
  type        = string
  default     = null
}

variable "flavor_name" {
  description = "Name of the Nova flavor (sizing)."
  type        = string
}

variable "key_pair" {
  description = "Name of an existing Nova key pair to inject."
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Nova availability zone (null = scheduler default)."
  type        = string
  default     = null
}

variable "networks" {
  description = "Networks to attach. Provide name OR uuid per entry."
  type = list(object({
    name     = optional(string)
    uuid     = optional(string)
    fixed_ip = optional(string)
  }))
}

variable "security_groups" {
  description = "Security groups applied to the instance."
  type        = list(string)
  default     = ["default"]
}

variable "metadata" {
  description = "Key/value metadata attached to the instance."
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "cloud-init user data (raw string)."
  type        = string
  default     = null
}

variable "boot_from_volume" {
  description = "Boot from a new Cinder root volume instead of ephemeral disk."
  type = object({
    enabled               = optional(bool, false)
    image_id              = optional(string) # required when enabled
    size_gb               = optional(number, 20)
    volume_type           = optional(string)
    delete_on_termination = optional(bool, true)
  })
  default = {}
}

variable "floating_ip_pool" {
  description = "External network/pool to allocate a floating IP from (null = none)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags applied to the instance."
  type        = list(string)
  default     = ["terraform"]
}
