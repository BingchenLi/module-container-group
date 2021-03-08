resource "azurerm_container_group" "container" {
  name                = "${var.project}-container"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  ip_address_type     = "private"
  network_profile_id  = azurerm_network_profile.np.id
  os_type             = "linux"
  restart_policy      = var.restart_policy

  dynamic "container" {
    for_each = var.containers_config

    content {
      name = container.key

      image  = container.value.image
      cpu    = lookup(container.value, "cpu", 0.5)
      memory = lookup(container.value, "memory", 1.5)

      dynamic "ports" {
        for_each = lookup(container.value, "ports", {})

        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }

      environment_variables        = lookup(container.value, "environment_variables", {})
      secure_environment_variables = lookup(container.value, "secure_environment_variables", {})

      dynamic "volume" {
        for_each = lookup(container.value, "volume", {})

        content {
          name       = volume.value.name
          mount_path = volume.value.mount_path
          read_only  = lookup(volume.value, "read_only", false)
          share_name = volume.value.share_name

          storage_account_name = azurerm_storage_account.mount_storage_account[0].name
          storage_account_key  = azurerm_storage_account.mount_storage_account[0].primary_access_key
        }
      }
    }
  }
}
