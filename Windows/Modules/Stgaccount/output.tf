output "storage_account_name" {
  value       = azurerm_storage_account.this.name
  description = "The name of the storage account"
}

output "storage_account_id" {
  value       = azurerm_storage_account.this.id
  description = "The ID of the storage account"
}

output "container_name" {
  value       = var.create_container ? azurerm_storage_container.this[0].name : null
  description = "The name of the storage container"
}
