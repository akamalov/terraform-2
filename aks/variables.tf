variable "location" {
  description = "The default Azure region for the resource provisioning"
  default     = "West Europe"
}

variable "customer" {
  description = "Customer name"
}

variable "tags" {
  type = "map"
}

variable "storage_account" {
  type = "map"

  default = {
    "name" = ""
  }
}

variable "vnet_cidr" {
  description = "The vnet CIDR in classful format"
}
