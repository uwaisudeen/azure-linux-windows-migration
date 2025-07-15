resource "azurerm_virtual_network_peering" "vnet-peering" {
  name                      = var.peering_name
  resource_group_name       = var.source_resource_group_name
  virtual_network_name      = var.source_vnet_name
  remote_virtual_network_id = var.remote_vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.allow_gateway_transit
  use_remote_gateways          = var.use_remote_gateways
}
