resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = var.sql_version

  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password

  public_network_access_enabled = var.public_network_access_enabled

  minimum_tls_version = "1.2"

  tags = var.tags
}
