output "sqlmi_id" {
  description = "ID of the Azure SQL Managed Instance"
  value       = azurerm_mssql_managed_instance.sqlmi.id
}

output "sqlmi_fqdn" {
  description = "Fully qualified domain name of the SQL Managed Instance"
  value       = azurerm_mssql_managed_instance.sqlmi.fqdn
}

