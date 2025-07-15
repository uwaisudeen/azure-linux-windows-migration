output "id" {
  description = "Log Analytics Workspace ID"
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_id" {
  description = "Workspace ID (used in monitoring agents)"
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "name" {
  value = azurerm_log_analytics_workspace.this.name
}
