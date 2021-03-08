resource "azurerm_storage_account" "mount_storage_account" {
  count                    = var.mount_storage_account_name == null ? 0 : 1
  name                     = var.mount_storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "mount_file_shares" {
  count                = length(var.mount_file_share_name)
  name                 = var.mount_file_share_name[count.index]
  storage_account_name = azurerm_storage_account.mount_storage_account[0].name
  quota                = 5
}
