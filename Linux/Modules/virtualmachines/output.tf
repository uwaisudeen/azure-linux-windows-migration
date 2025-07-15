output "vm_ids" {
  value = {
    for vm_name, vm in azurerm_linux_virtual_machine.vm : vm_name => vm.id
  }
}

output "nic_ids" {
  value = {
    for nic_name, nic in azurerm_network_interface.nic : nic_name => nic.id
  }
}