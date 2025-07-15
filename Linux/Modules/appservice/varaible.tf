variable "name" {
  description = "Name of the App Service"
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

variable "app_service_plan_id" {
  description = "ID of the existing App Service Plan"
  type        = string
}

variable "linux_fx_version" {
  description = "Runtime stack (e.g., 'DOTNETCORE|6.0', 'NODE|18-lts')"
  type        = string
  default     = "DOTNETCORE|6.0"
}

variable "scm_type" {
  description = "Source control method (e.g., LocalGit, None)"
  type        = string
  default     = "LocalGit"
}

variable "app_settings" {
  description = "Application settings key-value pairs"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the App Service"
  type        = map(string)
  default     = {}
}
