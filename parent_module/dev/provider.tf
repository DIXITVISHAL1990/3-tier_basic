terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.55.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  tenant_id       = "8810bad7-7f76-4bba-8b17-d6d297d7bdd7"
  subscription_id = "2a238ca4-a95b-43d2-846c-1618b53c6203"
}
