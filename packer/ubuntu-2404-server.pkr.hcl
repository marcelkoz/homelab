
packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

variable "proxmox_node_name" {
  type    = string
  default = "proxmox"
}

variable "proxmox_vm_id" {
  type    = number
  default = 1000
}

variable "proxmox_vm_name" {
  type    = string
  default = "ubuntu-server-2404-template"
}

variable "proxmox_template_description" {
  type    = string
  default = "Ubuntu Server 24.04 (LTS) Image"
}

variable "proxmox_vm_disk_size" {
  type    = string
  default = "64G"
}

variable "proxmox_vm_cpu_cores" {
  type    = string
  default = "2"
}

variable "proxmox_vm_memory" {
  type    = string
  default = "4096"
}

variable "ubuntu_iso_filename" {
  type = string
}

variable "ubuntu_iso_checksum" {
  type = string
}

variable "ubuntu_iso_checksum_algorithm" {
  type = string
}

source "proxmox" "ubuntu-server-template" {
  node                 = var.proxmox_node_name
  vm_id                = var.proxmox_vm_id
  vm_name              = var.proxmox_vm_name
  template_description = var.proxmox_template_description

  cores      = var.proxmox_vm_cpu_cores
  memory     = var.proxmox_vm_memory
  qemu_agent = true

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  boot_iso {
    type         = "scsi"
    iso_file     = "local:iso/${var.ubuntu_iso_filename}"
    unmount      = true
    iso_checksum = "${var.ubuntu_iso_checksum_algorithm}:${var.ubuntu_iso_checksum}"
  }

  scsi_controller = "virtio-scsi-pci"
  disks {
    disk_size         = var.proxmox_vm_disk_size
    format            = "raw"
    storage_pool      = "local-lvm"
    storage_pool_type = "lvm"
    type              = "virtio"
  }

  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }
}

build {

}
