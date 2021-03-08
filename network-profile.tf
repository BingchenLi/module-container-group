resource "azurerm_network_profile" "np" {
  name                = "${var.project}netprofile"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  container_network_interface {
    name = "${var.project}containerni"

    ip_configuration {
      name      = "${var.project}ipconfig"
      subnet_id = data.azurerm_subnet.container_subnet.id
    }
  }
}
