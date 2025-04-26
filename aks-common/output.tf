output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.workspace.id
}

output "dns_zone_name_servers" {
  description = "The Azure DNS zone nameservers"
  value       = azurerm_dns_zone.bp_zone.name_servers
}
