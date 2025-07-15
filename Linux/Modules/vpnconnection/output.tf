output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = azurerm_virtual_network_gateway_connection.this.id
}
