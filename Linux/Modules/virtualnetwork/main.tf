resource "azurerm_virtual_network" "vnets" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnets.name
  address_prefixes     = each.value.address_prefixes

  dynamic "delegation" {
    for_each = (
      try(each.value.delegation_name != null && 
          each.value.service_delegation_name != null &&
          each.value.service_delegation_actions != null, false)
    ) ? [1] : []

    content {
      name = each.value.delegation_name

      service_delegation {
        name    = each.value.service_delegation_name
        actions = each.value.service_delegation_actions
      }
    }
  }
}
