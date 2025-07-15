data "azurerm_resource_group" "shared" {
  name = "win-rg"

}

data "azurerm_public_ip" "publicip" {
  resource_group_name = data.azurerm_resource_group.shared.name
  name = "pip-vpngw"
}

data "azurerm_virtual_network" "hub-vnet" {
  name = "Hub-Vnet"
  resource_group_name = data.azurerm_resource_group.shared.name
}
module "onprem_vnet" {
  source = "../Modules/virtualnetwork"
  vnet_name ="onprem-vnet"
  resource_group_name = data.azurerm_resource_group.shared.name
  location = data.azurerm_resource_group.shared.location
  address_space = ["10.1.0.0/16"]
  tags = {
    network = "onprem"
  }

  subnets = {
    subnetvm1 = {
      address_prefixes = ["10.1.0.0/24"] 
    }
    GatewaySubnet = {
      address_prefixes = ["10.1.2.0/27"]
    }
    AzureBastionSubnet = {
      address_prefixes = ["10.1.3.0/24"]
    }
  }
}

module "vms" {
  source = "../Modules/vmwindows"
  vm_config = {
    onpremHyperV ={
      vm_size = "Standard_D4s_v5"
      publisher = "MicrosoftWindowsServer"
      offer = "WindowsServer"
      sku = "2022-datacenter-g2"
    }
    onpremSQLVM = {
      vm_size = "Standard_D4s_v5"
      publisher = "MicrosoftSQLServer"
      offer = "SQL2019-WS2022"
      sku = "Standard"
    }
  }
    subnet_id = module.onprem_vnet.subnet_ids["subnetvm1"]
  location = data.azurerm_resource_group.shared.location
  admin_username = "demouser"
  admin_password = "Azure123"
  resource_group_name = data.azurerm_resource_group.shared.name

}
resource "azurerm_virtual_machine_extension" "sql_dsc_config" {
  name                 = "SQLVMConfig"
  virtual_machine_id   = module.vms.vm_ids["onpremSQLVM"]
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.9"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    configuration = {
      url      = "https://raw.githubusercontent.com/microsoft/TechExcel-Securely-migrate-Windows-Server-and-SQL-Server-workloads-to-Azure/main/Hands-on lab/resources/deployment/onprem/sql-vm-config.zip"
      script   = "sql-vm-config.ps1"
      function = "Main"
    }
  })
}

resource "azurerm_virtual_machine_extension" "install_hyperv" {
  name                       = "InstallHyperV"
  virtual_machine_id         = module.vms.vm_ids["onpremHyperV"]
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    fileUris = [
      "https://raw.githubusercontent.com/microsoft/TechExcel-Securely-migrate-Windows-Server-and-SQL-Server-workloads-to-Azure/main/Hands-on lab/resources/deployment/onprem/install-hyper-v.ps1"
    ],
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ./install-hyper-v.ps1"
  })
}

resource "azurerm_virtual_machine_extension" "create_winserver_vm_dsc" {
  name                       = "CreateWinServerVM"
  virtual_machine_id         = module.vms.vm_ids["onpremHyperV"]
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.9"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    configuration = {
      url      = "https://raw.githubusercontent.com/microsoft/TechExcel-Securely-migrate-Windows-Server-and-SQL-Server-workloads-to-Azure/main/Hands-on lab/resources/deployment/onprem/create-vm.zip"
      script   = "create-vm.ps1"
      function = "Main"
    }
  })

}

module "vpn_pub_ip" {
  source = "../Modules/publicip"
  public_ips ={
    vpn_pip = {
      name = "onprem-vpn-publicip"
      allocation_method = "Static"
      sku = "Standard"
      domain_name_label = "gateway-pip-label"
      tags = { network = "onprem" }
    }
    AzureBastion = {
      name = "onprem-AzureBastion-publicip"
      allocation_method = "Static"
      sku = "Standard"
      domain_name_label = "azurebastion-pip-label"
      tags = { network = "onprem" }
    }
  }
    location = data.azurerm_resource_group.shared.location
    resource_group_name = data.azurerm_resource_group.shared.name
}

module "onprem_vpn" {
  source = "../Modules/vpngateway"
  gateway_name = "onprem-vpn"
  location = data.azurerm_resource_group.shared.location
  gateway_subnet_id = module.onprem_vnet.subnet_ids["GatewaySubnet"]
  resource_group_name = data.azurerm_resource_group.shared.name
  enable_bgp = true
  gateway_sku = "VpnGw2"
  public_ip_id = module.vpn_pub_ip.public_ip_ids["vpn_pip"]
  tags ={
      network = "onnprem"
    }
}

module "onprem-lng" {
  source = "../Modules/localnetworkgateway"
    name = "onprem-lng"
    location = data.azurerm_resource_group.shared.location
    resource_group_name = data.azurerm_resource_group.shared.name
    gateway_address = data.azurerm_public_ip.publicip.ip_address
    address_space = data.azurerm_virtual_network.hub-vnet.address_space
    tags = {
      network = "onnprem"
    }
}

module "nsg" {
  source = "../Modules/nsg"
  nsg_name = "onprem-nsg"
  location = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name
  security_rules =[
    {
      name                       = "RDP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  tags = {
     network = "onnprem"
  }
}

module "nsg-association-to-subnetvm1" {
  source = "../Modules/nsgassociation"
  subnetid =[ 
       { subnet_id = module.onprem_vnet.subnet_ids["subnetvm1"]},
  ]
  nsg_id = module.nsg.nsg_id
   depends_on = [module.onprem_vnet]
}

module "vnet-gateway-connection" {
  source = "../Modules/vpnconnection"
  name = "onprem-hub-vpnconnection"
  resource_group_name = data.azurerm_resource_group.shared.name
  location = data.azurerm_resource_group.shared.location
  vnet_gateway_id = module.onprem_vpn.gateway_id
  local_gateway_id = module.onprem-lng.local_network_gateway_id
  shared_key             = "Sharedkey123!" 
  enable_bgp             = false

  tags = {
    network = "onnprem"
    purpose     = "VPN Site-to-Site"
  }
}

module "onprem-bastion" {
  source = "../Modules/bastionhost"
  name = "onprem-bastion-host"
  resource_group_name = data.azurerm_resource_group.shared.name
  location = data.azurerm_resource_group.shared.location
  subnet_id = module.onprem_vnet.subnet_ids["AzureBastionSubnet"]
  public_ip_id = module.vpn_pub_ip.public_ip_ids["AzureBastion"]
  tags = {
    environment = "dev"
  }

}