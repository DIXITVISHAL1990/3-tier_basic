resource "azurerm_mssql_database" "sql_db" {
  name      = var.sql_db_name
  server_id = var.sql_server_id

  sku_name  = var.sku_name
  max_size_gb = var.max_size_gb

  zone_redundant = var.zone_redundant

  tags = var.tags
}
