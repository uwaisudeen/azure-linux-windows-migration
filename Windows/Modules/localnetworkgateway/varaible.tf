variable "name" {
  type        = string
  description = "Name of the Local Network Gateway"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "gateway_address" {
  type        = string
  description = "Public IP address of the on-premises VPN device"
}

variable "address_space" {
  type        = list(string)
  description = "List of on-premises address prefixes"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
