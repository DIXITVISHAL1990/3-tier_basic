# variables.tf

variable "pip_name" {
  description = "Name of the public IP"
  type        = string
}

variable "rg_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed"
  type        = string
}

variable "allocation_method" {
  description = "Allocation method for public IP (Static or Dynamic)"
  type        = string
}
