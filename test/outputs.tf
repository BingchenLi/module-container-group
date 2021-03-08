output "container_group" {
  value = module.ContainerGroup.container_group
}

output "container_group_ip_address" {
  value = module.ContainerGroup.container_group_ip_address
}

output "mount_storage_account" {
  value = module.ContainerGroup.mount_storage_account
}

output "mount_file_shares" {
  value = module.ContainerGroup.mount_file_shares
}

output "mount_storage_account_key" {
  value = module.ContainerGroup.mount_storage_account_key
}

output "network_profile_id" {
  value = module.ContainerGroup.network_profile_id
}
