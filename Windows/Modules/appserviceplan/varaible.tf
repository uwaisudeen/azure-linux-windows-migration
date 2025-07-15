variable "name" {
  description = "Name of the App Service Plan"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "kind" {
  description = "Specifies the kind of the App Service Plan (e.g., Linux, Windows)"
  type        = string
  default     = "Linux"
}

variable "reserved" {
  description = "Is this App Service Plan reserved for Linux?"
  type        = bool
  default     = true
}

variable "sku_tier" {
  description = "Tier of the App Service Plan (e.g., Free, Basic, Standard, Premium)"
  type        = string
  default     = "Basic"
}

variable "sku_size" {
  description = "Size of the App Service Plan (e.g., B1, P1v2)"
  type        = string
  default     = "B1"
}

variable "tags" {
  description = "Tags to apply to the App Service Plan"
  type        = map(string)
  default     = {}
}
