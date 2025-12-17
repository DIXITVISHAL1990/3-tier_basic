variable "secret_name" {
  description = "Name of the Key Vault secret"
  type        = string
}

variable "secret_value" {
  description = "Secret value to store in Key Vault"
  type        = string
  sensitive   = true
}

variable "key_vault_id" {
  description = "Key Vault ID"
  type        = string
}
