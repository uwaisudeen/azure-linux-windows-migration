variable "name" {
  type        = string
  description = "Name of the private DNS zone (e.g., privatelink.postgres.database.azure.com)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the DNS zone will be created"
}


variable "tags" {
  type    = map(string)
  default = {}
}
