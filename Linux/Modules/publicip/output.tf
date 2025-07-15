output "public_ip_ids" {
  description = "Map of Public IP resource IDs"
  value       = { for k, ip in azurerm_public_ip.this : k => ip.id }
}

output "public_ip_addresses" {
  description = "Map of Public IP addresses"
  value       = { for k, ip in azurerm_public_ip.this : k => ip.ip_address }
}
