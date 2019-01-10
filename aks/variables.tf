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