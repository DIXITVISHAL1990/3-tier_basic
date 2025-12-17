resource "azurerm_key_vault" "this" {
  name                = var.kv_name
  location            = var.location
  resource_group_name = var.rg_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled  = false

  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete"
    ]
  }
}


