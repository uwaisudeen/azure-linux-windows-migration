variable "name" {
  type        = string
  description = "Name of the route table"
}

variable "location" {
  type        = string
  description = "Location of the resources"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "routes" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string) # Only required for VirtualAppliance
  }))
  description = "List of routes"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the route table"
}
