variable "vms" {
  description = "Map of VM names to configurations"
  type = map(object({
    vm_size   = string
    subnet_id = string
    vmpublic_ip = string
  }))
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VM login"
  type        = string
}

variable "admin_password" {
  description = "Admin password for VM login"
  type        = string
  sensitive   = true
}