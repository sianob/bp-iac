resource_group_name = "rg-staging-bp-cluster"
location            = "CentralUS"
cluster_name        = "aks-bp-cluster"
aks_environment     = "staging"
kubernetes_version  = "1.31.7"
system_node_count   = 1
log_analytics_workspace_id = "/subscriptions/ca190604-52a6-4995-bf81-ed45b383360c/resourceGroups/rg-monitoring-bp/providers/Microsoft.OperationalInsights/workspaces/log-aks-bp"