variable "mi_name" {
  description = "Name of the Azure SQL Managed Instance"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name where the resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to deploy the managed instance into (must be a dedicated subnet)"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the SQL Managed Instance"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the SQL Managed Instance"
  type        = string
  sensitive   = true
}
