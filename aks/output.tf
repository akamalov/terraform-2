output "resource_group_name" {
  value = "${module.resource_group.resource_group_name}"
}

output "terraform_workspace" {
  value = "${terraform.workspace}"
}
