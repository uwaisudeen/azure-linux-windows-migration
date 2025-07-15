resource "azurerm_firewall_policy" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_firewall_policy_rule_collection_group" "network" {
  count              = length(var.network_rule_collections)
  name               = var.network_rule_collections[count.index].name
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = var.network_rule_collections[count.index].priority

  network_rule_collection {
    name                 = var.network_rule_collections[count.index].name
    action               = var.network_rule_collections[count.index].action
 priority           = var.network_rule_collections[count.index].priority
    dynamic "rule" {
      for_each = var.network_rule_collections[count.index].rules
      content {
        name                  = rule.value.name
        protocols             = rule.value.protocols
        source_addresses      = rule.value.source_addresses
        destination_addresses = rule.value.destination_addresses
        destination_ports     = rule.value.destination_ports
      }
    }
  }
}
