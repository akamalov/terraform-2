provider "azurerm" {
  version = "~> 1.21"
}

provider "random" {
  version = "~> 2.0"
}

provider "null" {
  version = "~> 1.0"
}

terraform {
  backend "azurerm" {}
}

locals {
  resource_group_name = "${var.customer}-${terraform.workspace}"      # dynamic build of RG name
  default_secret_name = "${terraform.workspace}-secret"
  create_resource     = "${terraform.workspace == "default" ? 0 : 1}" # condition to prevent creating resources with a "default" terraform workspace
}

module "resource_group" {
  source              = "github.com/jungopro/terraform-modules.git?ref=dev/azure/resource_group"
  count               = "${local.create_resource}"
  resource_group_name = "${local.resource_group_name}"
  location            = "${var.location}"
  tags                = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "storage_account" {
  source                   = "github.com/jungopro/terraform-modules.git?ref=dev/azure/storage_account"
  count                    = 2
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
  resource_group  = "${module.resource_group.resource_group_name}"
  location        = "${var.location}"
  sa_id           = "${element("${module.storage_account.id}", 0)}"
  tags            = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "vnet" {
  source              = "github.com/jungopro/terraform-modules.git?ref=dev/azure/vnet"
  create_resource     = "${local.create_resource}"
  name                = "${module.resource_group.resource_group_name}-primary-vnet"
  resource_group_name = "${module.resource_group.resource_group_name}"
  cidr                = "${var.vnet_cidr}"
  location            = "${var.location}"
  tags                = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "backend_subnet" {
  source            = "github.com/jungopro/terraform-modules.git?ref=dev/azure/subnet"
  create_resource   = "${local.create_resource}"
  name              = "${module.vnet.vnet_name}-backend-subnet"
  resource_group    = "${module.resource_group.resource_group_name}"
  address_prefix    = "${var.backend_address_prefix}"
  vnet_name         = "${module.vnet.vnet_name}"
  service_endpoints = "${var.backend_endpoints}"
}

module "frontend_subnet" {
  source            = "github.com/jungopro/terraform-modules.git?ref=dev/azure/subnet"
  create_resource   = "${local.create_resource}"
  name              = "${module.vnet.vnet_name}-frontend-subnet"
  resource_group    = "${module.resource_group.resource_group_name}"
  address_prefix    = "${var.frontend_address_prefix}"
  vnet_name         = "${module.vnet.vnet_name}"
  service_endpoints = "${var.frontend_endpoints}"
}
