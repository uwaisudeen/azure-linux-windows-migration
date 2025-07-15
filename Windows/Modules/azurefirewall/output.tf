output "firewall_id" {
  value       = azurerm_firewall.this.id
  description = "ID of the Azure Firewall"
}

output "private_ip" {
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
  description = "Private IP of the Azure Firewall"
}
