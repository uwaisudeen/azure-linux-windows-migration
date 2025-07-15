data "azurerm_resource_group" "shared" {
  name = "win-rg"
}

module "spoke_vnet" {
  source              = "../Modules/virtualnetwork"
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = data.azurerm_resource_group.shared.location
  vnet_name           = "spoke-vnet"
  address_space       = ["10.2.0.0/16"]
  tags = {
    network = "spoke"
  }

  subnets = {
    sql_subnet = {
      address_prefixes = ["10.2.1.0/27"]
      delegation_name             = "sql-delegation"
      service_delegation_name     = "Microsoft.Sql/managedInstances"
      service_delegation_actions  = ["Microsoft.Network/virtualNetworks/subnets/action"]
      service_endpoints          = ["Microsoft.Sql", "Microsoft.Storage"] 
    }

    vm_subnet ={
        address_prefixes =["10.2.4.0/27"]
    }
  }
}

module "sqlmi"{
    source= "../Modules/sqlmi"
    mi_name = "sqlmi-db"
    location = data.azurerm_resource_group.shared.location
    resource_group_name = data.azurerm_resource_group.shared.name
    subnet_id = module.spoke_vnet.subnet_ids["sql_subnet"]
    admin_username = "demouser"
    admin_password = "Azure123"
}

module "vms" {
  source = "../Modules/vmwindows"
  vm_config = {
    spokeHyperVHost ={
      vm_size = "Standard_D4s_v5"
      publisher = "MicrosoftWindowsServer"
      offer = "WindowsServer"
      sku = "2022-datacenter-g2"
    }
  }
  subnet_id = module.spoke_vnet.subnet_ids["vm_subnet"]
  location = data.azurerm_resource_group.shared.location
  admin_username = "demouser"
  admin_password = "Azure123"
  resource_group_name = data.azurerm_resource_group.shared.name
}


data "azurerm_virtual_network" "Hub_VNet" {
  name                = "Hub-Vnet"
  resource_group_name = "win-rg"
}
 
module "spoketohub_vnetpeering" {
  source = "../Modules/vnetpeering"
  peering_name = "spoke-hub"
  source_resource_group_name = data.azurerm_resource_group.shared.name
  source_vnet_name = module.spoke_vnet.vnet_name
  remote_vnet_id = data.azurerm_virtual_network.Hub_VNet.id
  allow_gateway_transit = false
  use_remote_gateways = false
}
 
module "hubtospoke_vnetpeering" {
  source = "../Modules/vnetpeering"
  peering_name = "hub-spoke"
  source_resource_group_name = data.azurerm_resource_group.shared.name
  source_vnet_name = data.azurerm_virtual_network.Hub_VNet.name
  remote_vnet_id = module.spoke_vnet.vnet_id
  allow_gateway_transit = false
  use_remote_gateways = false
}

