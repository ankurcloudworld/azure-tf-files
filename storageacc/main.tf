module "resource_group" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.1.0"
  name = "${var.resource_group_name}-${var.environment_name}"
  location            = var.location
}

resource "azurerm_storage_account" "sa" {
  name                     = "${var.storage_account_name}${var.environment_name}"
  resource_group_name      = module.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment_name
    purpose     = "testing-update"
  }
 
}
