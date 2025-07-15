

resource "azurerm_app_service" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  site_config {
    linux_fx_version = var.linux_fx_version
    always_on        = true
    scm_type         = var.scm_type
  }

  app_settings = var.app_settings

  tags = var.tags
}
