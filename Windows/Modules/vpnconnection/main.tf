resource "azurerm_virtual_network_gateway_connection" "this" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  type                            = "IPsec"
  virtual_network_gateway_id      = var.vnet_gateway_id
  local_network_gateway_id        = var.local_gateway_id
  connection_protocol             = "IKEv2"
  shared_key                      = var.shared_key
  enable_bgp                      = var.enable_bgp
  tags                            = var.tags
}
