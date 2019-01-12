provider "azurerm" {
  version = "~> 1.21"
}

terraform {
  backend "azurerm" {}
}

locals {
  resource_group_name = "${var.customer}-${terraform.workspace}"   # dynamic build of RG name
  default_secret_name = "${terraform.workspace}-secret"
  create_resource     = "${terraform.workspace == "default" ? 0 : 1}" # condition to prevent creating resources with a "default" terraform workspace
}

module "resource_group" {
  source              = "github.com/jungopro/terraform-modules.git?ref=dev/azure/resource_group"
  create_resource     = "${local.create_resource}"
  resource_group_name = "${local.resource_group_name}"
  location            = "${var.location}"
  tags                = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "storage_account" {
  source                   = "github.com/jungopro/terraform-modules.git?ref=dev/azure/storage_account"
  create_resource          = "${local.create_resource}"
  name                     = "${lower("${var.storage_account["name"]}")}"
  resource_group           = "${module.resource_group.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "${var.storage_account["account_tier"]}"
  account_replication_type = "${var.storage_account["account_replication_type"]}"
  tags                     = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "container_registry" {
  source          = "github.com/jungopro/terraform-modules.git?ref=dev/azure/container_registry"
  create_resource = "${local.create_resource}"
  name            = "${replace("${local.resource_group_name}acr", "-", "")}"
  resource_group  = "${local.resource_group_name}"
  location        = "${var.location}"
  sa_id           = "${element("${module.storage_account.id}", 0)}"
  tags            = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}
