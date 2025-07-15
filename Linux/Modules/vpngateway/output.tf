output "gateway_id" {
  description = "The ID of the Virtual Network Gateway"
  value       = azurerm_virtual_network_gateway.vpn_gw.id
}

output "gateway_name" {
  description = "Name of the Virtual Network Gateway"
  value       = azurerm_virtual_network_gateway.vpn_gw.name
}
