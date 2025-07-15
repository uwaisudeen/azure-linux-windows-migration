variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnets" {
  description = "Map of subnet names to their address prefixes and optional delegation"
  type = map(object({
    address_prefixes           = list(string)
    delegation_name            = optional(string)
    service_delegation_name    = optional(string)
    service_delegation_actions = optional(list(string))
  }))
  default = {}
}

variable "tags" {
  description = "Tags for the VNet"
  type        = map(string)
  default     = {}
}
