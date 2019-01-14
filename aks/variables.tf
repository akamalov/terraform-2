variable "location" {
  description = "The default Azure region for the resource provisioning"
  default = "West Europe"
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

variable "backend_address_prefix" {
  description = "The address prefix to use for the subnet in classful format"
}

variable "backend_endpoints" {
  description = "The list of Service endpoints to associate with the subnet. Possible values include:Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault,Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage"
  type = "list"
  default = []
}

variable "frontend_address_prefix" {
  description = "The address prefix to use for the subnet in classful format"
}

variable "frontend_endpoints" {
  description = "The list of Service endpoints to associate with the subnet. Possible values include:Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.EventHub, Microsoft.KeyVault,Microsoft.ServiceBus, Microsoft.Sql and Microsoft.Storage"
  type = "list"
  default = []
}

variable "key_vault_readers_group" {
  description = "Name of the group to create in AAD that will be granted read access to the key vault"
}
