output "volume_ids" {
  description = "Map of logical name => Cinder volume ID."
  value       = { for k, v in openstack_blockstorage_volume_v3.this : k => v.id }
}

output "attachments" {
  description = "Map of logical name => device path for attached volumes."
  value       = { for k, v in openstack_compute_volume_attach_v2.this : k => v.device }
}
