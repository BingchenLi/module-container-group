data "azurerm_subscription" "current_subscription" {
}

data "azurerm_subnet" "container_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.vnet_rg
}

data "azurerm_resource_group" "rg" {
  name = var.rg
}

