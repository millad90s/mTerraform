output "name" {
  description = "VM name."
  value       = var.name
}

output "ipv4" {
  description = "Primary IPv4 address of the VM."
  value       = data.external.info.result.ipv4
}

output "state" {
  description = "VM state reported by Multipass."
  value       = data.external.info.result.state
}
