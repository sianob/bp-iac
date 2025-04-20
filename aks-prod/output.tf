output "aks_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_fqdn" {
  value = azurerm_kubernetes_cluster.aks.fqdn
}

output "aks_node_rg" {
  value = azurerm_kubernetes_cluster.aks.node_resource_group
}

output "kubeconfig" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

# Output the public IP
# Might not be available immediately
# run 'terraform output ingress_nginx_public_ip'

output "ingress_nginx_public_ip" {
  value       = data.kubernetes_service.ingress_nginx.status[0].load_balancer[0].ingress[0].ip
  description = "Public IP address of the Ingress NGINX load balancer"
}