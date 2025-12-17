data "azurerm_key_vault_secret" "frontend_vm_pwd" {
  name         = "frontend-vm-password"
  key_vault_id = module.module_keyvault.kv_id
}

data "azurerm_key_vault_secret" "backend_vm_pwd" {
  name         = "backend-vm-password"
  key_vault_id = module.module_keyvault.kv_id
}

data "azurerm_key_vault_secret" "sql_admin_pwd" {
  name         = "sql-admin-password"
  key_vault_id = module.module_keyvault.kv_id
}

module "module_rg" {
  source   = "../../child_module/resource_gourp"
  rg_name  = var.rg_name
  location = var.location
}

module "module_vnet" {
  source        = "../../child_module/virtual_network"
  depends_on    = [module.module_rg]
  vnet_name     = var.vnet_name
  location      = var.location
  rg_name       = var.rg_name
  address_space = var.address_space
}

module "module_frontend_subnet" {
  source           = "../../child_module/subnet"
  depends_on       = [module.module_vnet]
  subnet_name      = var.frontend_subnet_name
  vnet_name        = var.vnet_name
  rg_name          = var.rg_name
  address_prefixes = var.frontend_address_prefixes
}

module "module_backend_subnet" {
  source           = "../../child_module/subnet"
  depends_on       = [module.module_vnet]
  subnet_name      = var.backend_subnet_name
  vnet_name        = var.vnet_name
  rg_name          = var.rg_name
  address_prefixes = var.backend_address_prefixes
}

module "module_bastion_subnet" {
  source           = "../../child_module/subnet"
  depends_on       = [module.module_vnet]
  subnet_name      = var.bastion_subnet_name
  vnet_name        = var.vnet_name
  rg_name          = var.rg_name
  address_prefixes = var.bastion_address_prefixes
}

module "module_frontend_nic" {
  source                        = "../../child_module/nic"
  nic_name                      = var.frontend_nic_name
  location                      = var.location
  rg_name                       = var.rg_name
  ip_configuration              = var.frontend_ip_configuration # Internal
  subnet_id                     = module.module_frontend_subnet.subnet_id
  private_ip_address_allocation = var.frontend_private_ip_address_allocation #"Dynamic"
}

module "module_backend_nic" {
  source                        = "../../child_module/nic"
  nic_name                      = var.backend_nic_name
  location                      = var.location
  rg_name                       = var.rg_name
  ip_configuration              = var.backend_ip_configuration # Internal
  subnet_id                     = module.module_backend_subnet.subnet_id
  private_ip_address_allocation = var.backend_private_ip_address_allocation #"Dynamic"
}

module "module_frontend-vm" {
  source                = "../../child_module/virtual_machine"
  vm_name               = var.frontend_vm_name
  rg_name               = var.rg_name
  location              = var.location
  size                  = var.frontend_size
  admin_username        = var.frontend_admin_username
  admin_password        = data.azurerm_key_vault_secret.frontend_vm_pwd.value
  network_interface_ids = [module.module_frontend_nic.nic_id]
  caching               = var.caching              #"ReadWrite"
  storage_account_type  = var.storage_account_type #"Standard_LRS"
  publisher             = var.publisher            # "Canonical"
  offer                 = var.offer                # "0001-com-ubuntu-server-jammy"
  sku                   = var.sku                  # "22_04-lts"
  image_version         = var.fvm_image_version    # "latest"
}

module "module_backend-vm" {
  source                = "../../child_module/virtual_machine"
  vm_name               = var.backend_vm_name
  rg_name               = var.rg_name
  location              = var.location
  size                  = var.backend_size
  admin_username        = var.backend_admin_username
  admin_password        = data.azurerm_key_vault_secret.backend_vm_pwd.value
  network_interface_ids = [module.module_backend_nic.nic_id]
  caching               = var.caching              #"ReadWrite"
  storage_account_type  = var.storage_account_type #"Standard_LRS"
  publisher             = var.publisher            # "Canonical"
  offer                 = var.offer                # "0001-com-ubuntu-server-jammy"
  sku                   = var.sku                  # "22_04-lts"
  image_version         = var.bvm_image_version    # "latest"
}

module "module_frontend_public_ip" {
  source            = "../../child_module/public_ip"
  depends_on        = [module.module_rg]
  pip_name          = var.frontend_pip_name
  rg_name           = var.rg_name
  location          = var.location
  allocation_method = var.frontend_allocation_method
}

module "module_backend_public_ip" {
  source            = "../../child_module/public_ip"
  depends_on        = [module.module_rg]
  pip_name          = var.backend_pip_name
  rg_name           = var.rg_name
  location          = var.location
  allocation_method = var.backend_allocation_method
}

module "module_keyvault" {
  source     = "../../child_module/keyvault"
  depends_on = [module.module_rg]
  kv_name    = var.kv_name
  # secret_name = var.secret_name
  location  = var.location
  rg_name   = var.rg_name
  tenant_id = var.tenant_id
  object_id = var.object_id
}

# VM and server Password
module "kv_frontend_vm_password" {
  source       = "../../child_module/keyvault_secret"
  secret_name  = "frontend-vm-password"
  secret_value = var.frontend_admin_password
  key_vault_id = module.module_keyvault.kv_id
}

module "kv_backend_vm_password" {
  source       = "../../child_module/keyvault_secret"
  secret_name  = "backend-vm-password"
  secret_value = var.backend_admin_password
  key_vault_id = module.module_keyvault.kv_id
}

module "kv_sql_admin_password" {
  source       = "../../child_module/keyvault_secret"
  secret_name  = "sql-admin-password"
  secret_value = var.sql_admin_password
  key_vault_id = module.module_keyvault.kv_id
}

module "module_sql_server" {
  source          = "../../child_module/sql_server"
  sql_server_name = var.sql_server_name
  rg_name         = var.rg_name
  location        = var.location

  admin_username = var.sql_admin_username
  admin_password = data.azurerm_key_vault_secret.sql_admin_pwd.value

  public_network_access_enabled = var.sql_public_network_access_enabled
}

module "module_sql_database" {
  source        = "../../child_module/sql_database"
  sql_db_name   = var.sql_db_name
  sql_server_id = module.module_sql_server.sql_server_id

  sku_name       = var.sql_sku_name
  max_size_gb    = var.sql_max_size_gb
  zone_redundant = var.sql_zone_redundant
}



