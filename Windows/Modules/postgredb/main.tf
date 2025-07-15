resource "azurerm_postgresql_flexible_server_database" "this" {
  name      = var.name
  server_id = var.server_id
  charset   = var.charset
  collation = var.collation

  # lifecycle {
  #   prevent_destroy = var.prevent_destroy
  # }

 
}
