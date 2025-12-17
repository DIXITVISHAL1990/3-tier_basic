
resource "azurerm_resource_group" "local-rg-devopsexpress" {
  name     = var.rg_name
  location = var.location
}