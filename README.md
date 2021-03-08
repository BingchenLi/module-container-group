# Container Group

## Table of Contents

- [About the module](#about-the-module)
- [Usage](#usage)
  - [Prerequisites](#prerequisites)
  - [Module call](#module-call)
  - [Input](#input)
  - [Output](#output)
- [Resources](#resources)

## About the module

This module defines an **ACI Container Group** with optionally mounted **Storage Account File Share**. The Container group can have one or more containers and each container can optionally have multiple File Share mounted.

The container group created by this module meant to be integrated into a VNet. Thus, right now this module only supports **Private** ip_address_type and **Linux** OS.

More details https://docs.microsoft.com/en-us/azure/container-instances/container-instances-container-groups

## Usage

### Prerequisites

The module assumes that the following resources are already created:

- Virtual network with a dedicated subnet for the container group.

- A resource group where all resource are created in

- Optional : if the container group needs a database connected, it can be set up in `enviroment_variables`.

### Module call

To use this module, you need to provide the `subscription id` that you want resources to be deployed to via `azuread provider`.

The following example code creates two Containers in the Container Group and a Storage Account with two File Share.

- Container Group : `app-container`
- Storage Account : `appstormount`
- File Share : `app-share-1`, `app-share-2`
- Container : `app-cron`, `app-web`
  - Container `app-cron` : image=`app/app-cron:latest`; cpu=`0.5` (default); memory=`1.5` (default)
  - Container `app-web` : image=`app/app-cron:latest`; cpu=`1`; memory=`2`; port=[`80`,`TCP`][`22`,`tcp`]; volume : `app-www-mnt-1` and `app-www-mnt-1`, respectively mount on `app-share-1` and `app-share-2`; environment_variables and secure_environment_variables configurations for the connection of DB server.

Example code:

```terraform

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

module "ContainerGroup" {
  source = "local_path_of_module_dir"

  # project or application name
  project = "app"

  # resource group name
  rg = "container-group-app-rg"

  # storage account to mount (optional)
  mount_storage_account_name = "appstormount"

  # file share to mount (optional). Limit < 10; depends on mount_storage_account_name
  mount_file_share_name = ["app-share-1", "app-share-2"]

  # vnet to integrate
  vnet_name = "vnet"

  # subnet to integrate
  subnet_name = "container-group-subnet"

  # vnet resource group
  vnet_rg = "vnet-rg"

  # container(s) configuration
  containers_config = {

    # container : app-cron
    "app-cron" = {
      image  = "app/app-cron:latest"
    }

    # container : app-web
    "app-web" = {
      image  = "app/app-www:latest"
      cpu    = 1
      memory = 2

      # list of ports that this container exposes (optional)
      ports = [
        {
          port     = 80
          protocol = "TCP"
        },
        {
          port     = 22
          protocol = "TCP"
        }
      ]

      # list of volumes mounted on this container (optional)
      volume = [
        {
          name       = "app-www-mnt-1"
          mount_path = "/mnt1"
          # optional, default : false
          read_only  = false
          share_name = "app-share-1"
        },
        {
          name       = "app-www-mnt-2"
          mount_path = "/mnt2"
          # optional
          read_only  = false
          share_name = "app-share-2"
        }
      ]

      # optional
      environment_variables = {
        "APP_DATABASE_HOST" = "app.mysql.database.azure.com"
        "APP_DATABASE_USER" = "myadm@app"
        "APP_DATABASE_NAME" = "app"
        "APP_DATABASE_PORT" = 3306
      }

      # optional
      secure_environment_variables = {
        "APP_DATABASE_PASS" = "db_password"
      }
    }
  }
}

```

### Input

| Name                       | Description                                                                                       | Type           | Default    | Required |
| -------------------------- | ------------------------------------------------------------------------------------------------- | -------------- | ---------- | :------: |
| rg                         | The resource group for resources deployed in this module                                          | `string`       | n/a        |   yes    |
| project                    | The project used for all resources in this module                                                 | `string`       | n/a        |   yes    |
| vnet_name                  | VNet where the container group is deoployed                                                       | `string`       | n/a        |   yes    |
| vnet_rg                    | Resource group of the VNet                                                                        | `string`       | n/a        |   yes    |
| subnet_name                | Subnet where the container group is deoployed                                                     | `string`       | n/a        |   yes    |
| mount_file_share_name      | Container(s) configuration                                                                        | `any`          | n/a        |   yes    |
| mount_storage_account_name | The name of mounted storage account                                                               | `string`       | `null`     |    no    |
| mount_file_share_name      | The list of names of mounted file share                                                           | `list(string)` | []         |    no    |
| restart_policy             | The restart policy for the container group. Available values are 'Always','Never' and 'onFailure' | `string`       | `"Always"` |    no    |

### Output

| Name                       | Description                                                        |
| -------------------------- | ------------------------------------------------------------------ |
| container_group            | container group name                                               |
| container_group_ip_address | container group ip address (private)                               |
| mount_storage_account      | mouted storage account name                                        |
| mount_file_shares          | mounted file share name                                            |
| mount_storage_account_key  | mounted storage account primary key                                |
| network_profile_id         | id of network profile of the subnet where container group deployed |

## Resources

This list contains all the resources this module may create. The module can create zero or more of each of these resources depending on the `count` value. The count value is determined at runtime. The goal of this page is to present the types of resources that may be created.

- `azurerm_container_group.container`
- `azurerm_storage_account.mount_storage_account`
- `azurerm_storage_share.mount_file_shares`
- `azurerm_network_profile.np`
