output "id" {
  description = "Instance UUID."
  value       = openstack_compute_instance_v2.this.id
}

output "name" {
  description = "Instance name."
  value       = openstack_compute_instance_v2.this.name
}

output "access_ip_v4" {
  description = "Primary IPv4 address detected by the provider."
  value       = openstack_compute_instance_v2.this.access_ip_v4
}

output "all_ipv4" {
  description = "All fixed IPv4 addresses across attached networks."
  value       = openstack_compute_instance_v2.this.network[*].fixed_ip_v4
}

output "floating_ip" {
  description = "Allocated floating IP (null when not requested)."
  value       = var.floating_ip_pool != null ? openstack_networking_floatingip_v2.this[0].address : null
}
