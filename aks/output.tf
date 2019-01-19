output "terraform_workspace" {
  value = "${terraform.workspace}"
}

output "resource_group_name" {
  value = "${module.resource_group.resource_group_name}"
}

output "storage_account_name" {
  value = "${module.storage_account.name}"
}

output "container_registry_name" {
  value = "${module.container_registry.name}"
}

output "vnet_name" {
  value = "${module.vnet.vnet_name}"
}

output "backend_subnet_name" {
  value = "${module.backend_subnet.subnet_name}"
}

output "backend_subnet_address_prefix" {
  value = "${module.backend_subnet.subnet_address_prefix}"
}

output "frontend_subnet_name" {
  value = "${module.frontend_subnet.subnet_name}"
}

output "frontend_subnet_address_prefix" {
  value = "${module.frontend_subnet.subnet_address_prefix}"
}

output "key_vault_name" {
  value = "${module.key_vault.name}"
}
