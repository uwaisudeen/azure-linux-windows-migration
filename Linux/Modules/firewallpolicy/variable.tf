variable "name" {
  description = "Name of the firewall policy"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the policy"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the policy"
  type        = map(string)
  default     = {}
}

variable "network_rule_collections" {
  description = "List of network rule collections"
  type = list(object({
    name     = string
    priority = number
    action   = string # "Allow" or "Deny"
    rules = list(object({
      name                  = string
      protocols             = list(string)    # e.g., ["TCP"]
      source_addresses      = list(string)    # e.g., ["10.1.0.0/24"]
      destination_addresses = list(string)    # e.g., ["*"]
      destination_ports     = list(string)    # e.g., ["80", "443"]
    }))
  }))
  default = []
}

