variable "proxmox" {
  type = object({
    api_url = string
    token_id = string
    token_secret = string
  })
}

variable base_vm {
  type = string
}

# create variables for cloud init username, password and ssh key
variable "cloud_init" {
  type = object({
    username = string
    password = string
    ssh_key = string
  })
  sensitive = true
}


# variables.tf
variable "VMs" {
  description = "VM configurations for master and worker nodes"
  type = map(object({
    vmid_start   = number
    count        = number
    ip_prefix    = string
    ip_start     = number
    subnet_mask  = string
    gateway      = string
    node         = string
    memory       = number
    cores        = number
    sockets      = number
    disk         = object({
      storage = string
      type = string
      size = string
    })
  }))
}