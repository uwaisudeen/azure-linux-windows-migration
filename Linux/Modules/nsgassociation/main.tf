resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = { for idx, subnet in var.subnetid : idx => subnet }
  subnet_id                 = each.value.subnet_id
  network_security_group_id = var.nsg_id 
}