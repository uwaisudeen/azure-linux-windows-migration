variable "name" {
  description = "Name of the PostgreSQL flexible server database"
  type        = string
}

variable "server_id" {
  description = "The ID of the PostgreSQL Flexible Server"
  type        = string
}

variable "charset" {
  description = "The charset to use in the database"
  type        = string
  default     = "UTF8"
}

variable "collation" {
  description = "The collation to use in the database"
  type        = string
  default     = "en_US.UTF8"
}

# variable "prevent_destroy" {
#   description = "Whether to prevent the database from being destroyed"
#   type        = bool
  
# }

# variable "depends_on" {
#   description = "List of dependencies"
#   type        = list(any)
#   default     = []
# }
