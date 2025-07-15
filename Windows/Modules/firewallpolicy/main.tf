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


resource "azurerm_firewall_policy_rule_collection_group" "application" {
  count              = length(var.application_rule_collections) > 0 ? 1 : 0
  name               = "${var.name}-app-rcg"
  firewall_policy_id = azurerm_firewall_policy.this.id
  priority           = 200

  dynamic "application_rule_collection" {
    for_each = var.application_rule_collections
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name                = rule.value.name
          source_addresses    = rule.value.source_addresses
          destination_fqdns   = rule.value.destination_fqdns

          dynamic "protocols" {
            for_each = rule.value.protocols
            content {
              type = protocols.value.type
              port = protocols.value.port
            }
          }
        }
      }
    }
  }
}
