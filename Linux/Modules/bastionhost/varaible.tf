variable "name" {
  description = "Name of the Bastion Host"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "ID of the AzureBastionSubnet"
  type        = string
}

variable "public_ip_id" {
  description = "ID of the Public IP to be used by Bastion"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
