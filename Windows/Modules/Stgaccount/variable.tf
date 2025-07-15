variable "prefix" {
  description = "Prefix for storage account name"
  type        = string
  default     = "stor"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "account_tier" {
  description = "Storage account tier"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "Replication type"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
  default     = {}
}

variable "create_container" {
  description = "Whether to create a storage container"
  type        = bool
  default     = true
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "default-container"
}

variable "container_access_type" {
  description = "Access type for container"
  type        = string
  default     = "private"
}
