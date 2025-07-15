output "vm_ids" {
  value = { for k, vm in azurerm_windows_virtual_machine.vm : k => vm.id }
}

output "nic_ids" {
  value = { for k, nic in azurerm_network_interface.nic : k => nic.id }
}
