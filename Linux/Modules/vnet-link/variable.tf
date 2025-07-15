variable "name" {
  type        = string
  description = "Name of the private DNS zone (e.g., privatelink.postgres.database.azure.com)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the DNS zone will be created"
}

  
variable "virtual_network_id" {
  description = "The ID of the virtual network to link to the Private DNS Zone."
  type        = string
}

variable "registration_enabled" {
  description = "Specifies if auto-registration of virtual machine records in the DNS zone is enabled."
  type        = bool
  default     = false
}


variable "private_dns_zone_name" {
  type = string
}