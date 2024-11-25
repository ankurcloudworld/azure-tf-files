# Data block to check for an existing resource group
data "azurerm_resource_group" "existing_rg" {
  name = var.resource_group_name
}

# Resource block to create the resource group if it doesn't exist
resource "azurerm_resource_group" "new_rg" {
  count = data.azurerm_resource_group.existing_rg.id != "" ? 0 : 1

  name     = var.resource_group_name
  location = var.location
}

# Use the appropriate resource group in the storage account
resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}${var.environment_name}"
  resource_group_name      = coalesce(try(data.azurerm_resource_group.existing_rg.name, null), try(azurerm_resource_group.new_rg[0].name, null))
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment_name
    team         = "cloud-ops"
  }
}
