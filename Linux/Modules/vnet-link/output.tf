output "private_dns_zone_vnet_link_name" {
  description = "The name of the private DNS zone virtual network link"
  value       = azurerm_private_dns_zone_virtual_network_link.this.name
}

output "private_dns_zone_vnet_link_id" {
  description = "The ID of the private DNS zone virtual network link"
  value       = azurerm_private_dns_zone_virtual_network_link.this.id
}

output "private_dns_zone_name" {
  description = "The name of the private DNS zone associated with the VNet link"
  value       = azurerm_private_dns_zone_virtual_network_link.this.private_dns_zone_name
}

output "linked_virtual_network_id" {
  description = "The ID of the virtual network linked to the private DNS zone"
  value       = azurerm_private_dns_zone_virtual_network_link.this.virtual_network_id
}
