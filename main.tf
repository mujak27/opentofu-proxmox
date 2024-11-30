
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_debug = true
  pm_log_enable = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
  pm_tls_insecure = true
  pm_api_url          = var.proxmox.api_url
  pm_api_token_id     = var.proxmox.token_id
  pm_api_token_secret = var.proxmox.token_secret
}

resource "proxmox_vm_qemu" "vms" {
  for_each = merge([
    for key, config in var.VMs : {
      for i in range(config.count) : "${key}-${i + 1}" => merge(config, {
        name     = "${key}-${i + 1}"
        vmid     = config.vmid_start + i
        ipconfig0 = "ip=${config.ip_prefix}${config.ip_start + i}/${config.subnet_mask},gw=${config.gateway}"
      })
    }
  ]...)

  vmid        = each.value.vmid
  name        = each.value.name
  target_node = each.value.node
  ipconfig0   = each.value.ipconfig0
  
  clone       = var.base_vm
  full_clone  = true
  
  cores       = each.value.cores
  sockets     = each.value.sockets
  memory      = each.value.memory
  
  disk {
    storage = each.value.disk.storage
    type    = each.value.disk.type
    size    = each.value.disk.size
  }
}


# resource "proxmox_vm_qemu" "workers" {
#   for_each          = var.masters
#   vmid              = each.value["vmid"]
#   name              = each.value["name"]
#   target_node       = each.value["node"]
#   # ipconfig0       = each.value["ipconfig0"]

#   # iso = var.iso
#   clone       = "template-talos"
#   full_clone  = true
#   # startup     = true

#   cores     = var.cores
#   sockets   = var.sockets
#   cpu       = var.cpu
#   memory    = var.memory
#   disk {
#     storage = var.disk.storage
#     type = var.disk.type
#     size = var.disk.size
#   }
# }