output "terraform_workspace" {
  value = "${terraform.workspace}"
}

output "resource_group_name" {
  value = "${module.resource_group.resource_group_name}"
}

output "storage_account_name" {
  value = "${module.storage_account.name}"
}
