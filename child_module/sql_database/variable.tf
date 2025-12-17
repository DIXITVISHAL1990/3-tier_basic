variable "sql_db_name" {
  type = string
}

variable "sql_server_id" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "Basic"
}

variable "max_size_gb" {
  type    = number
  default = 2
}

variable "zone_redundant" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
