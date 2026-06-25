locals {
  boot_volume = var.boot_from_volume.enabled ? var.boot_from_volume : null
}

resource "openstack_compute_instance_v2" "this" {
  name              = var.name
  image_name        = local.boot_volume == null ? var.image_name : null
  flavor_name       = var.flavor_name
  key_pair          = var.key_pair
  availability_zone = var.availability_zone
  security_groups   = var.security_groups
  metadata          = var.metadata
  user_data         = var.user_data
  tags              = var.tags

  dynamic "network" {
    for_each = var.networks
    content {
      name        = network.value.name
      uuid        = network.value.uuid
      fixed_ip_v4 = network.value.fixed_ip
    }
  }

  # Optional: boot from a freshly-created Cinder root volume.
  dynamic "block_device" {
    for_each = local.boot_volume == null ? [] : [local.boot_volume]
    content {
      uuid                  = block_device.value.image_id
      source_type           = "image"
      destination_type      = "volume"
      volume_size           = block_device.value.size_gb
      volume_type           = block_device.value.volume_type
      boot_index            = 0
      delete_on_termination = block_device.value.delete_on_termination
    }
  }

  lifecycle {
    ignore_changes = [image_name] # avoid spurious diffs after image rotation
  }
}

# Optional floating IP.
resource "openstack_networking_floatingip_v2" "this" {
  count = var.floating_ip_pool != null ? 1 : 0
  pool  = var.floating_ip_pool
}

resource "openstack_compute_floatingip_associate_v2" "this" {
  count       = var.floating_ip_pool != null ? 1 : 0
  floating_ip = openstack_networking_floatingip_v2.this[0].address
  instance_id = openstack_compute_instance_v2.this.id
}
