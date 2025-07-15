
variable "name" {
  description = "The name of the PostgreSQL Flexible Server"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "admin_username" {
  description = "Admin username"
  type        = string
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "The SKU name (e.g., Standard_B1ms, Standard_D2ds_v4)"
  type        = string
}

variable "postgresql_version" {
  description = "PostgreSQL version (e.g., 13, 14)"
  type        = string
}

variable "storage_mb" {
  description = "Storage size in MB (min 32768 MB)"
  type        = number
}



variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "configurations" {
  description = "Optional custom PostgreSQL server configurations"
  type        = map(string)
  default     = {}
}

variable "zone" {
  description = "The availability zone to deploy the PostgreSQL Flexible Server in"
  type        = string
  default     = "1"  # or "2" or "3", depending on region availability
}
