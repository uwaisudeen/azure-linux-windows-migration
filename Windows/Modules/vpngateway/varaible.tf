variable "gateway_name" {
  description = "Name of the Virtual Network Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "gateway_subnet_id" {
  description = "ID of the GatewaySubnet"
  type        = string
}

variable "gateway_sku" {
  description = "The SKU of the VPN Gateway (e.g., VpnGw1, VpnGw2)"
  type        = string
  default     = "VpnGw1"
}

variable "enable_bgp" {
  description = "Whether to enable BGP"
  type        = bool
  default     = false
}

variable "public_ip_id" {
  description = "ID of the Public IP address to associate with the VPN Gateway"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
