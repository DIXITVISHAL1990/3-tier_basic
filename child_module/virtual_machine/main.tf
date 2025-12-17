resource "azurerm_linux_virtual_machine" "local-vm" {
  name                  = var.vm_name
  resource_group_name   = var.rg_name
  location              = var.location
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = var.network_interface_ids

  os_disk {
    caching              = var.caching              #"ReadWrite"
    storage_account_type = var.storage_account_type #"Standard_LRS"
  }

  source_image_reference {
    publisher = var.publisher # "Canonical"
    offer     = var.offer     # "0001-com-ubuntu-server-jammy"
    sku       = var.sku       # "22_04-lts"
    version   = var.image_version  # "latest"
  }
}
