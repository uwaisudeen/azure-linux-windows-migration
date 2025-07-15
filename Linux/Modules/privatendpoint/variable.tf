variable "name" {
  description = "Name of the Private Endpoint"
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
  description = "ID of the subnet where the private endpoint will be created"
  type        = string
}

variable "private_service_connection_name" {
  description = "Name of the private service connection"
  type        = string
}

variable "target_resource_id" {
  description = "ID of the target resource (e.g., PostgreSQL server)"
  type        = string
}

variable "subresource_names" {
  description = "Subresource names for the private endpoint (e.g., [\"postgresqlServer\"])"
  type        = list(string)
}

variable "private_dns_zone_group_name" {
  description = "Name of the DNS zone group"
  type        = string
}

variable "private_dns_zone_ids" {
  description = "List of private DNS zone IDs"
  type        = list(string)
}

# variable "depends_on" {
#   description = "Resources this private endpoint depends on"
#   type        = list(any)
#   default     = []
# }
