terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.14"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.4.0"
    }
  }
}

resource "proxmox_pool" "k8s" {
  for_each = var.pm_k8s_nodes.keys
  poolid   = "k8s-${each.key}"
}

resource "proxmox_vm_qemu" "k8s" {
  for_each = {
    for vm in local.vms : "${vm.node}-${vm.no}" => vm
  }

  target_node = "proxmox"
  pool        = each.value.node
  agent       = 1

  name  = each.key
  desc  = "Talos k8s ${each.value.node} VM"
  clone = "talos-template"
  bios  = "ovmf"

  cores   = 4
  sockets = 1
  cpu     = "x86-64-v2-AES"
  memory  = 10280

  network {
    bridge = "vmbr01"
    model  = "virtio"
  }

  disk {
    storage = "talos-lvn"
    type    = "virtio"
    size    = "50G"
  }

  os_type   = "cloud-init"
  ipconfig0 = "ip=${each.value.address}"
}