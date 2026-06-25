output "id" {
  description = "Managed object ID of the VM."
  value       = vsphere_virtual_machine.this.id
}

output "name" {
  description = "VM name."
  value       = vsphere_virtual_machine.this.name
}

output "default_ip_address" {
  description = "Primary IP address reported by VMware Tools."
  value       = vsphere_virtual_machine.this.default_ip_address
}

output "uuid" {
  description = "BIOS UUID of the VM."
  value       = vsphere_virtual_machine.this.uuid
}
