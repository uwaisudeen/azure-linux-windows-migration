output "app_service_id" {
  description = "ID of the App Service"
  value       = azurerm_app_service.this.id
}

output "default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_app_service.this.default_site_hostname
}
