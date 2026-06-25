resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node_name
  vm_id        = var.vm_id
  description  = var.description
  tags         = var.tags
  unprivileged = var.unprivileged

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  disk {
    datastore_id = var.disk.datastore_id
    size         = var.disk.size_gb
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = var.os_type
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ip_config
        gateway = var.gateway
      }
    }

    user_account {
      keys = var.ssh_public_keys
    }
  }

  network_interface {
    name    = "eth0"
    bridge  = var.network_bridge
    vlan_id = var.vlan_id
  }
}
