variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group where the public IPs will be created"
  type        = string
}

variable "public_ips" {
  description = "Map of public IP configurations"
  type = map(object({
    name                = string
    allocation_method   = string
    sku                 = string
    domain_name_label   = string
    tags                = map(string)
  }))
}
