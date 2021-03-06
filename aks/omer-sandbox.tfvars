tags = {
    maintainer = "Omer Barel"
    environment = "sandbox"
}

customer = "omer"

storage_account = {
  "account_tier" = "Standard"
  "account_replication_type" = "LRS"
}

vnet_cidr = "172.16.0.0/16"

backend_address_prefix = "172.16.10.0/24"

backend_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]

frontend_address_prefix = "172.16.20.0/24"

frontend_endpoints = ["Microsoft.KeyVault","Microsoft.Storage"]

key_vault_enabled_for_deployment = true

key_vault_enabled_for_disk_encryption = true

key_vault_enabled_for_template_deployment = true