output "id" {
  value       = azurerm_postgresql_flexible_server.this.id
  description = "The ID of the PostgreSQL Flexible Server"
}

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.this.fqdn
  description = "The fully qualified domain name of the PostgreSQL server"
}

