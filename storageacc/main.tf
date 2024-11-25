# Fetch the resource group if it already exists
data "azurerm_resource_group" "existing_rg" {
  name     = var.resource_group_name
}

# Create the resource group only if it doesn't exist
resource "azurerm_resource_group" "new_rg" {
  count = length(data.azurerm_resource_group.existing_rg.id) > 0 ? 0 : 1

  name     = var.resource_group_name
  location = var.location
}

# Use the appropriate resource group
local {
  resource_group_name = length(data.azurerm_resource_group.existing_rg.id) > 0 ? 
    data.azurerm_resource_group.existing_rg.name : 
    azurerm_resource_group.new_rg[0].name
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}${var.environment_name}"
  resource_group_name      = local.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment_name
    team         = "cloud-ops"
  }
}
