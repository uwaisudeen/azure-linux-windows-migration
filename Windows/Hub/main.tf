module "rg" {
  source = "../Modules/resourcegroup"
  location = "centralindia"
  rg_name = "win-rg"
}


module "vnet_with_gateway" {
  source              = "../Modules/virtualnetwork"
  vnet_name          = "Hub-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name
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
  resource_group_name = module.rg.resource_group_name
  location = module.rg.resource_group_location
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




module "bastion" {
  source = "../Modules/bastionhost"
  name = "hub-bastion-host"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.resource_group_location
  subnet_id = module.vnet_with_gateway.subnet_ids["AzureBastionSubnet"]
  public_ip_id = module.publicip.public_ip_ids["bastion"]
  tags = {
    environment = "dev"
  }

}

module "vpngateway" {
  source = "../Modules/vpngateway"
  gateway_name = "hub-vpngateway"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.resource_group_location

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
  resource_group_name = module.rg.resource_group_name
}


data "azurerm_virtual_network" "onprem_vnet" {
  name = "onprem-vnet"
  resource_group_name = module.rg.resource_group_name
}



module "localnetworkgateway" {

  source = "../Modules/localnetworkgateway"
  name = "hub-lngw"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.resource_group_location
  gateway_address = data.azurerm_public_ip.onprem_publicip.ip_address
  address_space = data.azurerm_virtual_network.onprem_vnet.address_space
  tags = {
    environment="dev"
  }
  
}


module "vnet-gateway-connection" {
  source = "../Modules/vpnconnection"
  name = "hub-onprem-vpnconnection"
  resource_group_name = module.rg.resource_group_name
  location = module.rg.resource_group_location
  vnet_gateway_id = module.vpngateway.gateway_id
  local_gateway_id = module.localnetworkgateway.local_network_gateway_id
  shared_key             = "Sharedkey123!" 
  enable_bgp             = false

  tags = {
    environment = "dev"
    purpose     = "VPN Site-to-Site"
  }
}


module "firewall" {
  source = "../Modules/azurefirewall"
  name = "hub_firewall"
  location = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
  subnet_id = module.vnet_with_gateway.subnet_ids["AzureFirewallSubnet"]
  public_ip_id = module.publicip.public_ip_ids ["firewall"]
  firewall_policy_id = module.firewall_policy.firewall_policy_id
  tags = {
    environment = "dev"
  }
}

module "firewall_policy" {
  source              = "../Modules/firewallpolicy"
  name                = "hub-fw-pol"
  location            = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name

  # network_rule_collections = [
  #   {
  #     name     = "coll-deny-all-internet"
  #     priority = 1000
  #     action   = "Deny"
  #     rules = [
  #       {
  #         name                  = "Deny_All_Internet"
  #         source_addresses      = ["10.2.0.0/24"] # VM subnet
  #         destination_addresses = ["*"]
  #         destination_ports     = ["80", "443"]
  #         protocols             = ["TCP"]
  #       }
  #     ]
  #   }
  # ]

 application_rule_collections = [
  {
    name     = "App-Coll01"
    priority = 200
    action   = "Allow"
    rules = [
      {
        name                = "AllowBing"
        source_addresses    = ["10.2.0.0/24"]
        destination_fqdns   = ["www.bing.com"]
        protocols = [
          { type = "Http", port = 80 },
          { type = "Https", port = 443 }
        ]
      }
    ]
  }
]


  tags = {
    environment = "Hub"
    purpose     = "Firewall with App Rule"
  }
}




module "route_table" {
  source              = "../Modules/routetable"
  name                = "rt-Hub-001"
  location            = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name

  routes = [
    {
      name                   = "route-fw-001"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.0.253.4"
    }
  ]

  tags = {
    network = "Hub"
  }

  depends_on = [module.firewall]
}


module "route_association" {
  source         = "../Modules/routetableassociation"
  route_table_id = module.route_table.route_table_id
  subnet_id      = module.vnet_with_gateway.subnet_ids["subnet1"]
}


module "storage" {
  source              = "../Modules/Stgaccount"
  prefix              = "Hub-stor"
  location            = module.rg.resource_group_location
  resource_group_name = module.rg.resource_group_name

  create_container       = true
  container_name         = "sql-backup"
  container_access_type  = "private"

  tags = {
    environment = "dev"
    owner       = "aflal"
  }
}
