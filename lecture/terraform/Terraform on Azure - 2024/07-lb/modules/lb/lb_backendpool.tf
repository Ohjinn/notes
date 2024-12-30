resource "azurerm_lb_backend_address_pool" "bep" {
    loadbalancer_id = azurerm_lb.lb.id
    name = "${var.prefix}-bep"
}
