resource "azurerm_app_service_plan" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = var.kind
  reserved            = var.reserved
  sku {
    tier = var.sku_tier
    size = var.sku_size
  }
  tags = var.tags
}