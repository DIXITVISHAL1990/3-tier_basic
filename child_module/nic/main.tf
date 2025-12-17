resource "azurerm_network_interface" "local-nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.ip_configuration # Internal
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation     #"Dynamic"
  }
}