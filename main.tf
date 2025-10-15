data "azurerm_service_plan" "existing" {
  name                = var.app_service_plan_name
  resource_group_name = var.app_service_plan_resource_group
}

data "azurerm_log_analytics_workspace" "existing" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_resource_group
}

data "azurerm_mysql_flexible_server" "existing" {
  name                = var.mysql_server_name
  resource_group_name = var.mysql_server_resource_group_name
}

resource "azurerm_resource_group" "main" {
  name     = "${ var.app_name }-rg"
  location = data.azurerm_service_plan.existing.location

  tags = {
    Environment = "shared"
    Project     = "tvbingefriend"
  }
}

resource "azurerm_storage_account" "main" {
  name                     = "${var.app_name}sa"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  tags = {
    Environment = "shared"
    Project     = "tvbingefriend"
  }
}

locals {
  index_queue              = "index-queue"
  details_queue            = "details-queue"
  seasons_queue            = "seasons-queue"
  episodes_queue           = "episodes-queue"
  show_ids_table           = "showidstable"
  recommendation_container = "recommendation-data"
  queues_to_create = toset([
    local.index_queue,
    "${local.index_queue}-stage",
    local.details_queue,
    "${local.details_queue}-stage",
    local.seasons_queue,
    "${local.seasons_queue}-stage",
    local.episodes_queue,
    "${local.episodes_queue}-stage"
  ])
  tables_to_create = toset([
    local.show_ids_table,
    "${local.show_ids_table}stage"
  ])
  containers_to_create = toset([
    local.recommendation_container
  ])
}

resource "azurerm_storage_queue" "main" {
  for_each           = local.queues_to_create
  name               = each.key
  storage_account_id = azurerm_storage_account.main.id
}

resource "azurerm_storage_table" "main" {
  for_each             = local.tables_to_create
  name                 = each.key
  storage_account_name = azurerm_storage_account.main.name
}

resource "azurerm_storage_container" "main" {
  for_each           = local.containers_to_create
  name               = each.key
  storage_account_id = azurerm_storage_account.main.id
}

# Azure container registry
resource "azurerm_container_registry" "main" {
  name                = "${var.app_name}acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = "true"
}
