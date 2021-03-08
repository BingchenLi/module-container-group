variable "project" {
  description = "The project used for all resources in this module"
  type        = string
}

variable "rg" {
  description = "The rg name where all resources in this module should be created"
  type        = string
}

variable "vnet_name" {
  description = "The name of vnet where the container group is deoployed."
  type        = string
}

variable "subnet_name" {
  description = "The name of subnet where the container group is deoployed."
  type        = string
}

variable "vnet_rg" {
  description = "The rg of the vnet."
  type        = string
}

variable "mount_storage_account_name" {
  description = "The name of mounted storage account."
  type        = string
  default     = null
}

variable "mount_file_share_name" {
  description = "The list of names of mounted file share."
  type        = list(string)
  default     = []
}

variable "restart_policy" {
  description = "The restart policy for the container group. Available values are 'Awalys','Never' and 'onFailure'.https://docs.microsoft.com/en-us/azure/container-instances/container-instances-restart-policy"
  type        = string
  default     = "Always"
}

variable "containers_config" {
  description = "Container(s) configuration."
  type        = any
}

