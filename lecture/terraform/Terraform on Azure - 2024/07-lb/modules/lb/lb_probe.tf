resource "azurerm_lb_probe" "lb-probe" {
    loadbalancer_id     = azurerm_lb.lb.id
    name                = "http-probe"
    protocol            = "Http"
    request_path        = "/"
    port                = 80
}
