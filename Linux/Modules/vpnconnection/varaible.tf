variable "name" {
  type        = string
  description = "Name of the connection"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "vnet_gateway_id" {
  type        = string
  description = "ID of the Virtual Network Gateway"
}

variable "local_gateway_id" {
  type        = string
  description = "ID of the Local Network Gateway"
}

variable "shared_key" {
  type        = string
  description = "Shared IPSec key"
}

variable "enable_bgp" {
  type        = bool
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
}
