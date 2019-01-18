tags = {
    maintaner = "Omer Barel"
    environment = "test"
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

key_vault_readers_group = "kv-readers"