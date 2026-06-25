output "nas_datastore_ids" {
  description = "Map of NAS datastore name => managed object ID."
  value       = { for k, v in vsphere_nas_datastore.this : k => v.id }
}

output "virtual_disk_paths" {
  description = "Map of disk key => VMDK path."
  value       = { for k, v in vsphere_virtual_disk.this : k => v.vmdk_path }
}
