variable "peering_name" {
  description = "Name of the VNet peering"
  type        = string
}

variable "source_resource_group_name" {
  description = "Resource group of the source VNet"
  type        = string
}

variable "source_vnet_name" {
  description = "Name of the source virtual network"
  type        = string
}

variable "remote_vnet_id" {
  description = "ID of the remote virtual network"
  type        = string
}

variable "allow_gateway_transit" {
  description = "Allow gateway transit"
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "Use remote gateways"
  type        = bool
  default     = false
}
