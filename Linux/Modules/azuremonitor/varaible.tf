variable "name" {
  description = "Name of the diagnostic setting"
  type        = string
}

variable "target_resource_id" {
  description = "The ID of the resource to monitor"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send logs to"
  type        = string
}

variable "log_categories" {
  description = "List of diagnostic log categories to enable"
  type        = list(string)
  default     = []
}

variable "metric_categories" {
  description = "List of metric categories to enable"
  type        = list(string)
  default     = []
}

variable "retention_enabled" {
  description = "Enable retention policy"
  type        = bool
  default     = false
}

variable "retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}
