resource "azurerm_lb_nat_pool" "lbnatpool" {
  resource_group_name            = "${var.prefix}-RG"
  name                           = "${var.prefix}-ssh-natpool"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50005
  frontend_ip_configuration_name = "${var.prefix}-pip"
  backend_port                   = 80
}
