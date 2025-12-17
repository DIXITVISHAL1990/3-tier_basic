resource "azurerm_bastion_host" "example" {
  name                = var.azure_bastion_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = var.bastion_ip_configuration_name
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}