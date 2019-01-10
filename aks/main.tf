provider "azurerm" {
}

terraform {
  backend "azurerm" {}
}

locals {
  resource_group_name = "${var.customer}-${terraform.workspace}-rg"   # dynamic build of RG name
  default_secret_name = "${terraform.workspace}-secret"
  create_resource     = "${terraform.workspace == "default" ? 0 : 1}" # condition to prevent creating resources with a "default" terraform workspace
}

module "resource_group" {
  source              = "github.com/jungopro/terraform-modules.git?ref=dev/azure/resource_group"
  create_resource     = "${local.create_resource}"                                                                                          # creates 1 instance of the resource if terraform.workspace isn't default
  resource_group_name = "${local.resource_group_name}"
  location            = "${var.location}"
  tags                = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}
