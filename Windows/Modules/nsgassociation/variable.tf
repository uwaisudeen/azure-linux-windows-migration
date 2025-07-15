variable "subnetid" {
  description = "The ID of the subnet"
  type = list(object({
    subnet_id  = string
  }))
  default = []
}

variable "nsg_id" {
  description = "The ID of the Network Security Group"
  type        = string
}