output "container_group" {
  value = azurerm_container_group.container.name
}

output "container_group_ip_address" {
  value = azurerm_container_group.container.ip_address
}

output "mount_storage_account" {
  value = azurerm_storage_account.mount_storage_account[0].name
}

output "mount_file_shares" {
  value = azurerm_storage_share.mount_file_shares[*].name
}

output "mount_storage_account_key" {
  value = azurerm_storage_account.mount_storage_account[0].primary_access_key
}

output "network_profile_id" {
  value = azurerm_network_profile.np.id
}
