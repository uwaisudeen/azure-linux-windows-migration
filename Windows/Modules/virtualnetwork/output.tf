output "vnet_id" {
  value = azurerm_virtual_network.vnets.id
}

output "vnet_name" {
  value = azurerm_virtual_network.vnets.name
}

output "subnet_ids" {
  value = {
    for name, subnet in azurerm_subnet.subnets : name => subnet.id
  }
}
