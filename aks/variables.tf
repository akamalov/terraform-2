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

variable "key_vault_sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are Standard and Premium"
  default = "standard"
}

variable "key_vault_enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault"
  default = false
}

variable "key_vault_enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys"
  default = false
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault"
  default = false
}

## aks variables

/*variable "aks_admin_username" {
  description = "(Required) The Admin Username for the Cluster. Changing this forces a new resource to be created."
  default = "admin"
}

variable "aks_key_data" {
  description = "The Public SSH Key used to access the cluster. Changing this forces a new resource to be created."
}

variable "aks_vm_size" {
  description = "The size of each VM in the Agent Pool (e.g. Standard_F1). Changing this forces a new resource to be created"
}

variable "aks_os_disk_size" {
  description = "The Agent Operating System disk size in GB. Changing this forces a new resource to be created"
}

variable "max_pods" {
  description = "The maximum number of pods that can run on each agent"
}*/