
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "billing-optimizer-rg"
  location = "East US"
}

resource "azurerm_storage_account" "blob_storage" {
  name                     = "billingstorageacct"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_cosmosdb_account" "cosmos" {
  name                = "billingcosmosacct"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "billing_db" {
  name                = "billingdb"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmos.name
}

resource "azurerm_storage_container" "billing_container" {
  name                  = "billing-records"
  storage_account_name  = azurerm_storage_account.blob_storage.name
  container_access_type = "private"
}
