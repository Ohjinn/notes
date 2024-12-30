resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = "${var.resource_group_name_prefix}-RSGR"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = "${var.resource_group_name_prefix}-cluster"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${var.resource_group_name_prefix}-dns"

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.node_count
    min_count = 2
    max_count = 6
    enable_auto_scaling = true
    
    vnet_subnet_id  = var.vnet_subnet_id
    zones = ["1", "2", "3"]
    max_pods        = 100  # 각 노드당 100개의 Pod 제한
  }

  
  linux_profile {
    admin_username = var.username

    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
}
