variable "name" {
  type        = string
  description = "Name of the Log Analytics Workspace"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group where the workspace will be created"
}

variable "sku" {
  type        = string
  default     = "PerGB2018"
  description = "SKU for the workspace (e.g., PerGB2018, Free, etc.)"
}

variable "retention_in_days" {
  type        = number
  default     = 30
  description = "Number of days to retain data"
}

variable "daily_quota_gb" {
  type        = number
  default     = -1
  description = "The daily ingestion quota in GB. -1 means no limit."
}

variable "tags" {
  type    = map(string)
  default = {}
}
