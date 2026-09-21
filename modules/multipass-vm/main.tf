locals {
  cloud_init = var.cloud_init != null ? var.cloud_init : (
    length(var.ssh_public_keys) == 0 ? null : yamlencode({ ssh_authorized_keys = var.ssh_public_keys })
  )
  cloud_init_content = local.cloud_init == null ? null : (
    startswith(local.cloud_init, "#cloud-config") ? local.cloud_init : "#cloud-config\n${local.cloud_init}"
  )
}

resource "local_file" "cloud_init" {
  count    = local.cloud_init_content == null ? 0 : 1
  filename = "${path.module}/.generated/${var.name}-cloud-init.yaml"
  content  = local.cloud_init_content
}

resource "terraform_data" "vm" {
  input = {
    name = var.name
  }

  triggers_replace = [var.image, var.cpus, var.memory, var.disk, local.cloud_init_content]

  provisioner "local-exec" {
    command = join(" ", compact([
      "multipass launch ${var.image}",
      "--name ${var.name}",
      "--cpus ${var.cpus}",
      "--memory ${var.memory}",
      "--disk ${var.disk}",
      local.cloud_init_content == null ? "" : "--cloud-init ${abspath(local_file.cloud_init[0].filename)}",
    ]))
  }

  provisioner "local-exec" {
    when    = destroy
    command = "multipass delete --purge ${self.input.name}"
  }
}

data "external" "info" {
  program    = ["bash", "-c", "multipass info ${var.name} --format json | jq '{ipv4: (.info[\"${var.name}\"].ipv4[0] // \"\"), state: .info[\"${var.name}\"].state}'"]
  depends_on = [terraform_data.vm]
}
