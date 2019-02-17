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

data "azurerm_client_config" "current" {}

module "resource_group" {
  source              = "github.com/jungopro/terraform-modules.git?ref=dev/azure/resource_group"
  count               = "${local.create_resource}"
  resource_group_name = "${local.resource_group_name}"
  location            = "${var.location}"
  tags                = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "storage_account" {
  source                   = "github.com/jungopro/terraform-modules.git?ref=dev/azure/storage_account"
  count                    = "${local.create_resource}"
  resource_group           = "${element("${module.resource_group.resource_group_name}", 0)}"
  location                 = "${var.location}"
  account_tier             = "${var.storage_account["account_tier"]}"
  account_replication_type = "${var.storage_account["account_replication_type"]}"
  tags                     = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "container_registry" {
  source         = "github.com/jungopro/terraform-modules.git?ref=dev/azure/container_registry"
  count          = "${local.create_resource}"
  name           = "${replace("${local.resource_group_name}acr", "-", "")}"
  resource_group = "${element("${module.resource_group.resource_group_name}", 0)}"
  location       = "${var.location}"
  sa_id          = "${element("${module.storage_account.id}", 0)}"
  tags           = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "vnet" {
  source              = "github.com/jungopro/terraform-modules.git?ref=dev/azure/vnet"
  count               = "${local.create_resource}"
  name                = "${element("${module.resource_group.resource_group_name}", 0)}-primary-vnet"
  resource_group_name = "${element("${module.resource_group.resource_group_name}", 0)}"
  cidr                = "${var.vnet_cidr}"
  location            = "${var.location}"
  tags                = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "backend_subnet" {
  source            = "github.com/jungopro/terraform-modules.git?ref=dev/azure/subnet"
  count             = "${local.create_resource}"
  name              = "${element("${module.vnet.vnet_name}",0)}-backend-subnet"
  resource_group    = "${element("${module.resource_group.resource_group_name}", 0)}"
  address_prefix    = "${var.backend_address_prefix}"
  vnet_name         = "${element("${module.vnet.vnet_name}",0)}"
  service_endpoints = "${var.backend_endpoints}"
}

module "frontend_subnet" {
  source            = "github.com/jungopro/terraform-modules.git?ref=dev/azure/subnet"
  count             = "${local.create_resource}"
  name              = "${element("${module.vnet.vnet_name}",0)}-frontend-subnet"
  resource_group    = "${element("${module.resource_group.resource_group_name}", 0)}"
  address_prefix    = "${var.frontend_address_prefix}"
  vnet_name         = "${element("${module.vnet.vnet_name}",0)}"
  service_endpoints = "${var.frontend_endpoints}"
}

module "key_vault" {
  source                          = "github.com/jungopro/terraform-modules.git?ref=dev/azure/key_vault"
  count                           = "${local.create_resource}"
  name                            = "${element("${module.resource_group.resource_group_name}", 0)}-kv"
  location                        = "${var.location}"
  resource_group                  = "${element("${module.resource_group.resource_group_name}", 0)}"
  sku_name                        = "${var.key_vault_sku_name}"
  tenant_id                       = "${data.azurerm_client_config.current.tenant_id}"
  enabled_for_deployment          = "${var.key_vault_enabled_for_deployment}"
  enabled_for_disk_encryption     = "${var.key_vault_enabled_for_disk_encryption}"
  enabled_for_template_deployment = "${var.key_vault_enabled_for_template_deployment}"
  tags                            = "${merge("${var.tags}", map("terraform workspace", "${terraform.workspace}"), map("customer", "${var.customer}"))}"
}

module "key_vault_access_policy" {
  source         = "github.com/jungopro/terraform-modules.git?ref=dev/azure/key_vault_access_policy"
  vault_name     = "${element("${module.key_vault.name}", 0)}"
  resource_group = "${element("${module.resource_group.resource_group_name}", 0)}"
  tenant_id      = "${data.azurerm_client_config.current.tenant_id}"
  object_id      = "d5ae059c-40d6-43fe-8333-5852bb4bde04"

  certificate_permissions = [
    "get",
    "list",
  ]
}

module "aks_ad_application" {
  source = "github.com/jungopro/terraform-modules.git?ref=dev/azure/ad_application"
  name = "${element("${module.resource_group.resource_group_name}", 0)}-aks-app"
}


/*module "aks" {
  source         = "github.com/jungopro/terraform-modules.git?ref=dev/azure/aks"
  count          = "${local.create_resource}"
  name            = "${element("${module.resource_group.resource_group_name}", 0)}-aks"
  location       = "${var.location}"
  resource_group = "${element("${module.resource_group.resource_group_name}", 0)}"
  admin_username = "${var.aks_admin_username}"
  key_data = "${var.aks_key_data}"
  vm_size = "${var.aks_vm_size}"
  os_disk_size = "${var.aks_os_disk_size}"
  max_pods = "${var.max_pods}"
}*/