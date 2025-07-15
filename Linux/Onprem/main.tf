data "azurerm_resource_group" "shared" {
  name = "Linux-rg"

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
    subnetvm2 = {
      address_prefixes = ["10.1.1.0/24"]
    }
    GatewaySubnet = {
      address_prefixes = ["10.1.2.0/27"]
    }
    AzureBastionSubnet = {
      address_prefixes = ["10.1.3.0/24"]
    }
    AzureFirewallSubnet = {
  address_prefixes = ["10.1.100.0/24"]
}
  }
}

module "vms" {
  source = "../Modules/virtualmachines"
  vms = {
    onprem-workload ={
      vm_size = "Standard_D2s_v3"
      subnet_id = module.onprem_vnet.subnet_ids["subnetvm1"]
      vmpublic_ip =module.vpn_pub_ip.public_ip_ids["vm1-pip"]
    }
    onprem-app = {
      vm_size = "Standard_D2s_v3"
      subnet_id = module.onprem_vnet.subnet_ids["subnetvm2"]
      vmpublic_ip =module.vpn_pub_ip.public_ip_ids["vm2-pip"]
    }
  }
  location = data.azurerm_resource_group.shared.location
  admin_username = "demouser"
  admin_password = "Azure123"
  resource_group_name = data.azurerm_resource_group.shared.name

}
resource "azurerm_virtual_machine_extension" "install_script" {
  name                 = "workload-InstallScript"
  virtual_machine_id   = module.vms.vm_ids["onprem-workload"]
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    fileUris = [
      "https://raw.githubusercontent.com/microsoft/TechExcel-Migrate-Linux-workloads/main/resources/deployment/onprem/PG-workload-install.sh"
    ]
    commandToExecute = "sh PG-workload-install.sh"
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
    afw-onprem-pip = {
      name              = "pip-afw-onprem-001"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = "afw-onprem-label"
      tags = {
        network = "onprem"
      }
      }
    vm1-pip = {
      name = "vm1-pip"
      allocation_method = "Static"
      sku = "Standard"
      domain_name_label = "vm1-pip-label"
      tags = { network = "onprem" }
    }
    vm2-pip = {
      name = "vm2-pip"
      allocation_method = "Static"
      sku = "Standard"
      domain_name_label = "vm2-pip-label"
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
      name                       = "HTTP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "PostgreSQL"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5432"
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
        { subnet_id = module.onprem_vnet.subnet_ids["subnetvm2"]}
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

module "firewall" {
  source              = "../Modules/azurefirewall"
  name                = "afw-onprem-001"
  location            = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name
  firewall_policy_id  = module.firewall_policy.firewall_policy_id
  subnet_id           = module.onprem_vnet.subnet_ids["AzureFirewallSubnet"]
  public_ip_id        = module.vpn_pub_ip.public_ip_ids["afw-onprem-pip"]
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags = {
    network = "onprem"
  }
}


module "firewall_policy" {
  source              = "../Modules/firewallpolicy"
  name                = "afwp-onprem-001"
  location            = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name

  network_rule_collections = [
    {
      name     = "coll-deny-all-internet"
      priority = 1000
      action   = "Deny"
      rules = [
        {
          name                  = "Deny_All_Internet"
          source_addresses      = ["10.1.0.0/24"]
          destination_addresses = ["*"]
          destination_ports     = ["80", "443"]
          protocols             = ["TCP"]
        }
      ]
    }
  ]

  tags = {
    environment = "onprem"
    purpose     = "Block outbound internet"
  }
}


module "route_table" {
  source              = "../Modules/routetable"
  name                = "rt-onprem-001"
  location            = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name

  routes = [
    {
      name                   = "route-fw-001"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.firewall.firewall_private_ip
    }
  ]

  tags = {
    network = "onprem"
  }
}

module "route_association" {
  source         = "../Modules/routetableassociation"
  route_table_id = module.route_table.route_table_id
  subnet_id      = module.onprem_vnet.subnet_ids["subnetvm1"]
}
