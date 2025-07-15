 resource "azurerm_mssql_managed_instance" "sqlmi" {
   name                         = var.mi_name
   resource_group_name          = var.resource_group_name
   location                     = var.location
   administrator_login          = "azureuser"
   administrator_login_password = "Password1234!"
   subnet_id                    = var.subnet_id
 
   license_type      = "LicenseIncluded"
   sku_name          = "GP_Gen5"
   vcores            = 8
   storage_size_in_gb = 256
   storage_account_type = "LRS"

 
 }
 