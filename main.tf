locals {
  index_queue = "index-queue"
  details_queue = "details-queue"
  show_ids_table = "showidstable"
  queues_to_create = toset([
    local.index_queue,
    "${local.index_queue}-stage",
    local.details_queue,
    "${local.details_queue}-stage"
  ])
  tables_to_create = toset([
    local.show_ids_table,
    "${local.show_ids_table}stage"
  ])
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = "shared"
    Project     = "tvbingefriend"
  }
}

resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    Environment = "shared"
    Project     = "tvbingefriend"
  }
}

resource "azurerm_storage_queue" "main" {
  for_each = local.queues_to_create
  name = each.key
  storage_account_name = azurerm_storage_account.main.name
}

resource "azurerm_storage_table" "main" {
  for_each = local.tables_to_create
  name = each.key
  storage_account_name = azurerm_storage_account.main.name
}