resource "openstack_blockstorage_volume_v3" "this" {
  for_each = var.volumes

  name              = each.key
  size              = each.value.size_gb
  description       = each.value.description
  volume_type       = each.value.volume_type
  availability_zone = each.value.availability_zone
  image_id          = each.value.image_id
  metadata          = each.value.metadata
}

# Attach volumes that specify an instance_id.
resource "openstack_compute_volume_attach_v2" "this" {
  for_each = {
    for k, v in var.volumes : k => v if v.instance_id != null
  }

  instance_id = each.value.instance_id
  volume_id   = openstack_blockstorage_volume_v3.this[each.key].id
  device      = each.value.device
}
