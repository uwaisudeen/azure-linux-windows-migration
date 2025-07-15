data "azurerm_resource_group" "shared" {
  name = "Linux-rg"
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
    app_subnet = {
      address_prefixes = ["10.2.1.0/24"]
      # No delegation here
    }
    postgresql_subnet = {
      address_prefixes           = ["10.2.2.0/24"]
      # delegation_name            = "delegation"
      # service_delegation_name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      # service_delegation_actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

data "azurerm_virtual_network" "Hub_VNet" {
  name                = "Hub-Vnet"
  resource_group_name = "Linux-rg"
}

# data "azurerm_virtual_network" "onprem_VNet" {
#   name                = "onprem-vnet"
#   resource_group_name = "Linux-rg"
# }


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


module "privatednszone_"{
  source                = "../Modules/privatednszone"
  name                  = "privatelink.postgres.database.azure.com"
  resource_group_name   = data.azurerm_resource_group.shared.name
  tags = {
    environment = "dev"
  }
}

module "vnet_link" {
  source = "../Modules/vnet-link"
  name = "vnetlink-onprem"
  resource_group_name = data.azurerm_resource_group.shared.name
  virtual_network_id =  module.spoke_vnet.vnet_id
  private_dns_zone_name = module.privatednszone_.dns_zone_name
  registration_enabled = false
}


module "postgresql_flexible_server"{
  source                = "../Modules/postgreserver"
   name                  = "cloud-postgre-sql-db"
  location              = data.azurerm_resource_group.shared.location
  resource_group_name   = data.azurerm_resource_group.shared.name
  admin_username        = "demouser"
  admin_password        = "Azure123@"
  sku_name              ="GP_Standard_D8s_v3"
  postgresql_version    = "16"
  storage_mb            = 32768
  zone = "1"
  tags = {
    environment = "dev"
  }

}


module "postgresql_private_endpoint" {
  source = "../Modules/privatendpoint"

  name                           = "tam-a-private-end"
  location                       = data.azurerm_resource_group.shared.location
  resource_group_name            = data.azurerm_resource_group.shared.name
  subnet_id                      = module.spoke_vnet.subnet_ids["postgresql_subnet"]
  private_service_connection_name = "pvt-psc"
  target_resource_id             = module.postgresql_flexible_server.id
  subresource_names              = ["postgresqlServer"]
  private_dns_zone_group_name   = module.privatednszone_.dns_zone_name
  private_dns_zone_ids          = [module.privatednszone_.dns_zone_id]
  depends_on                    = [module.postgresql_flexible_server,module.spoke_vnet]
}


module "postgresql_database" {
  source = "../Modules/postgredb"
  name             = "dev-pe-databse"
  server_id        = module.postgresql_flexible_server.id
  charset          = "UTF8"
  collation        = "en_US.utf8"
  # prevent_destroy  = false
  depends_on       = [module.postgresql_flexible_server.id]
}




module "appservicep-plan" {
  source = "../Modules/appserviceplan"
  name = "appserviceplan-webdev"
  location = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name
  kind = "Linux"
  reserved = true
  sku_tier = "Basic"
  sku_size = "B1"
  tags = {
    environment = "dev"
  }
}

module "appservice" {
  source = "../Modules/appservice"
  name = "appserviceaflal"
  resource_group_name = data.azurerm_resource_group.shared.name
  location = data.azurerm_resource_group.shared.location
  app_service_plan_id = module.appservicep-plan.app_service_plan_id
  linux_fx_version    = "PHP|8.3"
  scm_type            = "None"

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
    ENVIRONMENT              = "Development"
  }

  tags = {
    environment = "dev"
  }

}



