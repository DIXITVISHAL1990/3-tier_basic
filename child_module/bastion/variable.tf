
# Bastion Host Name
variable "azure_bastion_name" {
  type        = string
  description = "Name of the Azure Bastion host."
}

# Location / Region
variable "location" {
  type        = string
  description = "Azure Region where Bastion will be deployed."
}

# Resource Group Name
variable "rg_name" {
  type        = string
  description = "Name of the Resource Group."
}

# Bastion Subnet ID (AzureBastionSubnet ka subnet_id)
variable "bastion_subnet_id" {
  type        = string
  description = "Subnet ID for AzureBastionSubnet."
}

# Bastion IP Configuration Name
variable "bastion_ip_configuration_name" {
  type        = string
  description = "Name for Bastion IP configuration."
}

# Public IP Address ID (Bastion ke Public IP ka ID)
variable "public_ip_address_id" {
  type        = string
  description = "Public IP address ID used by Bastion."
}