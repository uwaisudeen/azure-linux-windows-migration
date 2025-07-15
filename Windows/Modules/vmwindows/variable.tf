variable "location" {
    type        = string
}
variable "resource_group_name" {
    type        = string
}

variable "vm_config" {
  description = "Map of VM names to their config (like size)"
  type        = map(object({
    vm_size = string
    publisher = string
    offer = string
    sku = string
  }))
}

variable "admin_username" {
    type        = string
}
variable "admin_password" {
    type        = string
  sensitive = true
}

variable "subnet_id" {
    type        = string
}
