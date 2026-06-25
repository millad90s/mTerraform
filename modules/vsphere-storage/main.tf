data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_host" "host" {
  name          = var.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

# NFS / NAS datastores mounted on the host.
resource "vsphere_nas_datastore" "this" {
  for_each = var.nas_datastores

  name            = each.key
  host_system_ids = [data.vsphere_host.host.id]

  type         = each.value.type
  remote_hosts = each.value.remote_hosts
  remote_path  = each.value.remote_path
  access_mode  = each.value.access_mode
}

# Standalone virtual disks (e.g. shared data volumes attached later to VMs).
resource "vsphere_virtual_disk" "this" {
  for_each = var.vmdk_disks

  size               = each.value.size_gb # size in GB
  vmdk_path          = each.value.path
  datacenter         = var.datacenter
  datastore          = each.value.datastore
  type               = each.value.type
  create_directories = true
}
