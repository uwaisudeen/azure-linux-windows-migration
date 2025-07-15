
module "resource_group" {
  source = "../Modules/resourcegroup"
  rg_name = "Linux-rg"
  location = "centralindia"
}


module "vnet_with_gateway" {
  source              = "../Modules/virtualnetwork"
  vnet_name          = "Hub-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  tags = {
    environment = "dev"
  }

  subnets = {
    subnet1 = {
      address_prefixes = ["10.0.1.0/24"]
    }
    GatewaySubnet = {
      address_prefixes = ["10.0.255.0/27"]
    }
      AzureBastionSubnet = {
      address_prefixes = ["10.0.254.0/27"]
    }
     AzureFirewallSubnet = {
      address_prefixes = ["10.0.253.0/26"]
    }
  }
}

module "publicip" {
  source = "../Modules/publicip"
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
  public_ips = {
    bastion = {
      name              = "pip-bastion"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = "bastion-pip-label"
      tags              = { environment = "dev" }
    }
    firewall = {
      name              = "pip-firewall"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = "firewall-pip-label"
      tags              = { environment = "dev" }
    }
    vpngw = {
      name              = "pip-vpngw"
      allocation_method = "Static"
      sku               = "Standard"
      domain_name_label = "vpngw-pip-label"
      tags              = { environment = "dev" }
    }
  }
}


module "firewall-policy" {
  source = "../Modules/firewallpolicy"
  name = "hub-firewall-policy"
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
  tags = {
    environment ="dev"
  }
  
}

module "firewall" {
  source = "../Modules/azurefirewall"
  name = "hub_firewall"
  location = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
  subnet_id = module.vnet_with_gateway.subnet_ids["AzureFirewallSubnet"]
  public_ip_id = module.publicip.public_ip_ids ["firewall"]
  firewall_policy_id = module.firewall-policy.id
  tags = {
    environment = "dev"
  }
}

module "bastion" {
  source = "../Modules/bastionhost"
  name = "hub-bastion-host"
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
  subnet_id = module.vnet_with_gateway.subnet_ids["AzureBastionSubnet"]
  public_ip_id = module.publicip.public_ip_ids["bastion"]
  tags = {
    environment = "dev"
  }

}

module "vpngateway" {
  source = "../Modules/vpngateway"
  gateway_name = "hub-vpngateway"
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location

  enable_bgp          = true
  gateway_sku         = "VpnGw2"
  gateway_subnet_id = module.vnet_with_gateway.subnet_ids["GatewaySubnet"]
  public_ip_id = module.publicip.public_ip_ids["vpngw"]
  tags = {
    environment = "dev"
    project     = "hub-network"
  }
  
}

data "azurerm_public_ip" "onprem_publicip" {
  name = "onprem-vpn-publicip"
  resource_group_name = module.resource_group.resource_group_name
}


data "azurerm_virtual_network" "onprem_vnet" {
  name = "onprem-vnet"
  resource_group_name = module.resource_group.resource_group_name
}



module "localnetworkgateway" {

  source = "../Modules/localnetworkgateway"
  name = "hub-lngw"
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
  gateway_address = data.azurerm_public_ip.onprem_publicip.ip_address
  address_space = data.azurerm_virtual_network.onprem_vnet.address_space
  tags = {
    environment="dev"
  }
  
}


module "vnet-gateway-connection" {
  source = "../Modules/vpnconnection"
  name = "hub-onprem-vpnconnection"
  resource_group_name = module.resource_group.resource_group_name
  location = module.resource_group.resource_group_location
  vnet_gateway_id = module.vpngateway.gateway_id
  local_gateway_id = module.localnetworkgateway.local_network_gateway_id
  shared_key             = "Sharedkey123!" 
  enable_bgp             = false

  tags = {
    environment = "dev"
    purpose     = "VPN Site-to-Site"
  }
}