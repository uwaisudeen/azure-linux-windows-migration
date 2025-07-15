variable "name" {
  type        = string
  description = "Name of the Azure Firewall"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group for the Firewall"
}

variable "sku_name" {
  type        = string
  default     = "AZFW_VNet"
  description = "SKU name (AZFW_VNet or AZFW_Hub)"
}

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "SKU tier (Standard or Premium)"
}

variable "subnet_id" {
  type        = string
  description = "ID of the AzureFirewallSubnet"
}

variable "public_ip_id" {
  type        = string
  description = "ID of the public IP assigned to the Firewall"
}

variable "firewall_policy_id" {
  type        = string
  default     = null
  description = "Optional Firewall Policy ID"
}

variable "zones" {
  type        = list(string)
  default     = []
  description = "Availability Zones (e.g., [\"1\", \"2\", \"3\"])"
}

variable "tags" {
  type    = map(string)
  default = {}
}
