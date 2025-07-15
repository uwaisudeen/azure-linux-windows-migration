output "bastion_host_id" {
  description = "ID of the Bastion Host"
  value       = azurerm_bastion_host.this.id
}
