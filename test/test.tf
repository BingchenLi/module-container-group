provider "azurerm" {
  features {}
  subscription_id = "subscription_id"
}

module "ContainerGroup" {
  source = "../../module-container-group"

  # project or application name
  project = "phpipam"

  # resource group name
  rg = "rg"

  # storage account to mount (optional)
  mount_storage_account_name = "phpipamstormount"

  # file share to mount (optional) limit < 10
  mount_file_share_name = ["phpipam-share-1"]

  # vnet to integrate
  vnet_name = "vnet-1"

  # subnet to integrate
  subnet_name = "container_group"

  # vnet resource group
  vnet_rg = "vnet-rg"

  # container(s) configuration
  containers_config = {

    # container : phpipam-web
    "phpipam-web" = {
      image = "phpipam/phpipam-www:latest"
      cpu    = 0.5
      memory = 1.5

      # list of ports that container exposes (optional)
      ports = [
        {
          port     = 80
          protocol = "TCP"
        }
      ]

      volume = [
        {
          name       = "phpipam-www-mnt"
          mount_path = "/mnt"
          # optional
          read_only  = false
          share_name = "phpipam-share-1"

          # storage_account_name = module.ContainerGroup.mount_storage_account
          # storage_account_key  = azurerm_storage_account.storage.primary_access_key
        }
      ]

      # optional
      environment_variables = {
        "IPAM_DATABASE_HOST" = "azure_database_for_mysql_host"
        "IPAM_DATABASE_USER" = "user_name"
        "IPAM_DATABASE_NAME" = "db_name"
        "IPAM_DATABASE_PORT" = 3306
      }

      # optional
      secure_environment_variables = {
        "IPAM_DATABASE_PASS" = "db_password"
      }
    }

    # container : phpipam-cron
    "phpipam-cron" = {

      environment_variables = {
        "IPAM_DATABASE_HOST" = "azure_database_for_mysql_host"
        "IPAM_DATABASE_USER" = "user_name"
        "IPAM_DATABASE_NAME" = "db_name"
        "IPAM_DATABASE_PORT" = 3306
      }

      secure_environment_variables = {
        "IPAM_DATABASE_PASS" = "db_password"
      }
    }
  }
}
