variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to associate with the route table"
}

variable "route_table_id" {
  type        = string
  description = "The ID of the route table to associate"
}
