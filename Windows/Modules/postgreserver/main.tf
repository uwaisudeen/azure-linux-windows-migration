resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.name
  location               = var.location
  resource_group_name    = var.resource_group_name
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  sku_name               = var.sku_name
  version                = var.postgresql_version
  storage_mb             = var.storage_mb
  zone = var.zone

  public_network_access_enabled = false

  tags = var.tags
}

