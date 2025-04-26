resource "azurerm_resource_group" "monitoring-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = "log-aks-bp"
  location            = var.location
  resource_group_name = azurerm_resource_group.monitoring-rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
